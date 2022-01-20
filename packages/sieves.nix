{ lib, writeText, writeScript, zsh, coreutils-full, rspamd, ... } @ pkgs:
let
  sievec = import ./sievec.nix pkgs;
  rspamd_host = "fd00:e621:e621:2::2";
  sa-learn-ham-script = writeScript "sa-learn-ham" ''
    #!${zsh}/bin/zsh

    tmpfile=$(${coreutils-full}/bin/mktemp /tmp/spam.XXXXXX)
    ${coreutils-full}/bin/cat > $tmpfile
    password=$(${coreutils-full}/bin/cat /run/secrets/services/dovecot/rspamd_password)

    ${coreutils-full}/bin/cat $tmpfile | ${rspamd}/bin/rspamc -P $password -h ${rspamd_host} learn_ham
    ${coreutils-full}/bin/cat $tmpfile | ${rspamd}/bin/rspamc -P $password -h ${rspamd_host} -w 5 -f 11 fuzzy_del

    ${coreutils-full}/bin/rm $tmpfile
  '';

  sa-learn-spam-script = writeScript "sa-learn-spam" ''
    #!${zsh}/bin/zsh

    tmpfile=$(${coreutils-full}/bin/mktemp /tmp/spam.XXXXXX)
    ${coreutils-full}/bin/cat > $tmpfile
    password=$(${coreutils-full}/bin/cat /run/secrets/services/dovecot/rspamd_password)

    ${coreutils-full}/bin/cat $tmpfile | ${rspamd}/bin/rspamc -P $password -h ${rspamd_host} learn_spam
    ${coreutils-full}/bin/cat $tmpfile | ${rspamd}/bin/rspamc -P $password -h ${rspamd_host} -w 5 -f 11 fuzzy_add

    ${coreutils-full}/bin/rm $tmpfile
  '';
  removeStore = location: lib.removePrefix "/nix/store/" "${location}";
in
{
  default = sievec {
    name = "default";
    src = writeText "default.sieve" ''
      require "fileinto";
      if header :contains "X-Spam" "YES" {
        fileinto "Junk";
      }
    '';
    exts = [ "fileinto" ];
  };
  report-ham = sievec {
    name = "report-ham";
    src = writeText "report-ham.sieve" ''
      require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

      if environment :matches "imap.mailbox" "*" {
        set "mailbox" "$${1}";
      }
      
      if string "$${mailbox}" [ "Trash", "train_ham", "train_prob", "train_spam" ] {
        stop;
      }

      pipe :copy "${removeStore sa-learn-ham-script}";
    '';
    exts = [ "vnd.dovecot.pipe" "copy" "imapsieve" "environment" "variables" ];
  };
  report-spam = sievec {
    name = "report-spam";
    src = writeText "report-spam.sieve" ''
      require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "imap4flags"];

      if environment :is "imap.cause" "COPY" {
          pipe :copy "${removeStore sa-learn-spam-script}";
      }

      # Catch replied or forwarded spam
      elsif anyof (allof (hasflag "\\Answered",
                          environment :contains "imap.changedflags" "\\Answered"),
                   allof (hasflag "$Forwarded",
                          environment :contains "imap.changedflags" "$Forwarded")) {
          pipe :copy "${removeStore sa-learn-spam-script}";
      }
    '';
    exts = [ "vnd.dovecot.pipe" "copy" "imapsieve" "environment" "imap4flags" ];
  };
}
