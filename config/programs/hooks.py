import gpg

from email.mime.base import MIMEBase
from email.encoders import encode_base64
from email.utils import parseaddr

from alot.db.attachment import Attachment
from alot.settings.const import settings
from alot import crypto, errors
import alot

import re
import gpg
import os
import shutil
import signal
import subprocess
import tempfile

from contextlib import contextmanager

async def pre_envelope_send(ui=None, dbm=None, cmd=None):
    e = ui.current_buffer.envelope
    att = r".*(\battach(ed|ing)?\b|\bhere's|\bhere\s+is)"
    if (
        re.match(att, e.body_txt, re.DOTALL | re.IGNORECASE)
        and not e.attachments
    ):
        msg = 'No attachments. Send anyway?'
        if not (await ui.choice(msg, select='yes')) == 'yes':
            raise Exception("Send aborted")

def pre_buffer_focus(ui, dbm, buf):
	if buf.modename == 'search':
		buf.rebuild()

def post_buffer_focus(ui, dbm, buf, success):
    if success and hasattr(buf, "focused_thread"):  # if buffer has saved focus
        if buf.focused_thread is not None:
            tid = buf.focused_thread.get_thread_id() 
            for pos, tlw in enumerate(buf.threadlist.get_lines()):
                if tlw.get_thread().get_thread_id() == tid:
                    buf.body.set_focus(pos)
                    break

def pre_buffer_open(ui, dbm, buf):
    current = ui.current_buffer
    if isinstance(current, alot.buffers.SearchBuffer):
        current.focused_thread = current.get_selected_thread()   # remember focus


def text_quote(message):
    # avoid importing a big module by using a simple heuristic to guess the
    # right encoding
    def decode(s, encodings=('ascii', 'utf8', 'latin1')):
        for encoding in encodings:
            try:
                return s.decode(encoding)
            except UnicodeDecodeError:
                pass
        return s.decode('ascii', 'ignore')
    lines = message.splitlines()
    if len(lines) == 0:
        return ""
    # delete empty lines at beginning and end (some email client insert these
    # outside of the pgp signed message...)
    if lines[0] == '' or lines[-1] == '':
        from itertools import dropwhile
        lines = list(dropwhile(lambda l: l == '', lines))
        lines = list(reversed(list(dropwhile(lambda l: l == '', reversed(lines)))))
    if len(lines) > 0 and lines[0] == '-----BEGIN PGP MESSAGE-----' \
            and lines[-1] == '-----END PGP MESSAGE-----':
        try:
            sigs, d = crypto.decrypt_verify(message.encode('utf-8'))
            message = decode(d)
        except errors.GPGProblem:
            pass
    elif len(lines) > 0 and lines[0] == '-----BEGIN PGP SIGNED MESSAGE-----' \
            and lines[-1] == '-----END PGP SIGNATURE-----':
        # gpgme does not seem to be able to extract the plain text part of a signed message
        import gnupg
        gpg = gnupg.GPG()
        d = gpg.decrypt(message.encode('utf8'))
        message = d.data.decode('utf8')
    quote_prefix = settings.get('quote_prefix')
    return "\n".join([quote_prefix + line for line in message.splitlines()])



def _get_inline_keys(content):
    if BEGIN_KEY not in content:
        return []

    keys = []
    while content:
        start = content.find(BEGIN_KEY)
        if start == -1:
            # there are no more inline keys
            break
        content = content[start:]
        end = content.find(END_KEY) + len(END_KEY)
        key = content[0:end]
        keys.append(key)
        content = content[end:]

    return keys


def _get_attached_keys(attachments):
    keys = []
    for attachment in attachments:
        content_type = attachment.get_content_type()
        if content_type == 'application/pgp-keys':
            keys.append(attachment.get_data())
    return keys


@contextmanager
def temp_gpg_context():
    tempdir = tempfile.mkdtemp()
    tempctx = gpg.Context()
    tempctx.set_engine_info(gpg.constants.PROTOCOL_OpenPGP, home_dir=tempdir)
    try:
        yield tempctx
    finally:
        # Kill any gpg-agent's that have been opened
        lookfor = 'gpg-agent --homedir {}'.format(tempdir)
        out = subprocess.check_output(['ps', 'xo', 'pid,cmd'],
                                      stderr=open('/dev/null', 'w'))
        for each in out.strip().split('\n'):
            pid, cmd = each.strip().split(' ', 1)
            if cmd.startswith(lookfor):
                os.kill(int(pid), signal.SIGKILL)
        shutil.rmtree(tempdir)


async def import_keys(ui):
    ui.notify('Looking for keys in message...')
    m = ui.current_buffer.get_selected_message()
    content = m.get_text_content()
    attachments = m.get_attachments()
    inline = _get_inline_keys(content)
    attached = _get_attached_keys(attachments)
    keys = inline + attached

    if not keys:
        ui.notify('No keys found in message.')
        return

    for keydata in keys:
        with temp_gpg_context() as tempctx:
            tempctx.op_import(keydata)
            key = [k for k in tempctx.keylist()].pop()
            fpr = key.fpr
            uids = [u.uid for u in key.uids]
        confirm = 'Found key %s with uids:' % fpr
        for uid in uids:
            confirm += '\n  %s' % uid
        confirm += '\nImport key into keyring?'
        if (await ui.choice(confirm, select='yes')) == 'yes':
            # ***ATTENTION*** - operation in real keyring
            ctx = gpg.Context()
            ctx.op_import(keydata)
            ui.notify('Key imported: %s' % fpr)


#
# Attach key
#

def _key_to_mime(ctx, fpr):
    """
    Return an 'application/pgp-keys' MIME part containing an ascii-armored
    OpenPGP public key.
    """
    filename = '0x{}.pub.asc'.format(fpr)
    key = gpg.Data()
    ctx.op_export(fpr, 0, key)
    key.seek(0, 0)
    content = key.read()
    part = MIMEBase('application', 'pgp-keys')
    part.set_payload(content)
    encode_base64(part)
    part.add_header('Content-Disposition', 'attachment', filename=filename)
    return part


def _attach_key(ui, pattern):
    """
    Attach an OpenPGP public key to the current envelope.
    """
    ctx = gpg.Context()
    ctx.armor = True
    keys = _list_keys(pattern)
    for key in keys:
        part = _key_to_mime(ctx, key.fpr)
        attachment = Attachment(part)
        ui.current_buffer.envelope.attachments.append(attachment)
        ui.notify('Attached key %s' % key.fpr)
    ui.current_buffer.rebuild()


def _list_keys(pattern):
    """
    Return a list of OpenPGP keys that match the given pattern.
    """
    ctx = gpg.Context()
    ctx.armor = True
    keys = [k for k in ctx.keylist(pattern)]
    return keys


async def attach_keys(ui):
    """
    Query the user for a pattern, search the default keyring, and offer to
    attach matching keys.
    """
    pattern = await ui.prompt('Search for key to attach')
    ui.notify('Looking for "{}" in keyring...'.format(pattern))
    keys = _list_keys(pattern)

    if not keys:
        ui.notify('No keys found.')
        return

    for key in keys:
        prompt = []
        fpr = "{}".format(key.fpr)
        prompt.append("Key 0x{}:".format(fpr))
        for uid in key.uids:
            prompt.append("  {}".format(uid.uid))
        prompt.append('Attach?')
        if (await ui.choice('\n'.join(prompt), select='yes')) == 'yes':
            _attach_key(ui, fpr)


def attach_my_key(ui):
    """
    Attach my own OpenPGP public key to the current envelope.
    """
    sender = ui.current_buffer.envelope.get('From', "")
    address = parseaddr(sender)[1]
    acc = settings.account_matching_address(address)
    fpr = acc.gpg_key.fpr
    return _attach_key(ui, fpr)


def attach_recipient_keys(ui):
    """
    Attach the OpenPGP public keys of all the recipients of the email.
    """
    to = ui.current_buffer.envelope.get('To', "")
    cc = ui.current_buffer.envelope.get('Cc', "")
    for recipient in to.split(',') + cc.split(','):
        address = parseaddr(recipient)[1]
        if address:
            _attach_key(ui, address)
