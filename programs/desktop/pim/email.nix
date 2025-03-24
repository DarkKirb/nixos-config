{
  pkgs,
  config,
  lib,
  ...
}:
let
  mailcap = pkgs.writeText "mailcap" ''
    text/html; ${lib.getExe pkgs.w3m} -I %{charset} -T text/html; copiousoutput;
    image/*; ${lib.getExe pkgs.imv} %s
  '';
in
{
  accounts.email.accounts.lotte = {
    address = "lotte@chir.rs";
    gpg = {
      encryptByDefault = true;
      key = "B4E3D4801C49EC5E";
      signByDefault = true;
    };
    imap = {
      host = "imappro.zoho.eu";
      port = 993;
    };
    imapnotify = {
      enable = true;
      onNotify = "${lib.getExe pkgs.isync} lotte";
      onNotifyPost = "${lib.getExe pkgs.notmuch} new && ${lib.getExe pkgs.libnotify} 'New mail arrived'";
    };
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      extraConfig.account = {
        AuthMechs = "plain";
        PipelineDepth = 128;
      };
    };
    msmtp = {
      enable = true;
      extraConfig.auth = "plain";
    };
    neomutt.enable = true;
    notmuch.enable = true;
    passwordCommand = [
      "${lib.getExe' pkgs.coreutils "cat"}"
      config.sops.secrets."accounts/email/accounts/lotte/password".path
    ];
    realName = "Charlotte 🦝 Deleńkec";
    smtp = {
      host = "smtppro.zoho.eu";
      port = 465;
    };
    thunderbird.enable = true;
    userName = "lotte@chir.rs";
    primary = true;
  };
  accounts.email.maildirBasePath = "Maildir";
  sops.secrets."accounts/email/accounts/lotte/password".sopsFile = ./secrets.yaml;
  sops.secrets."accounts/email/accounts/darkkirb/sshKey".sopsFile = ./secrets.yaml;
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
  systemd.user.services.imapnotify.Unit = {
    Wants = [ "sops-nix.service" ];
    After = [ "sops-nix.service" ];
  };
  home.persistence.default.directories = [ "Maildir" ];
  services.muchsync.remotes.nas = {
    remote.host = "nas.int.chir.rs";
    sshCommand = "${lib.getExe pkgs.openssh} -CTaxq  -i ${
      config.sops.secrets."accounts/email/accounts/darkkirb/sshKey".path
    }";
  };
  programs.afew = {
    enable = true;
    extraConfig = ''
      [ArchiveSentMailsFilter]
      [DMARCReportInspectionFilter]
      [HeaderMatchingFilter.1]
      header = X-Spam
      pattern = Yes
      tags = +spam
      [KillThreadsFilter]
      [ListMailsFilter]
      [Filter.0]
      query = tag:new
      tags = +inbox;+unread;-new
    '';
  };
  programs.neomutt = {
    enable = true;
    binds = [
      {
        key = "\\CA";
        action = "sidebar-next";
        map = [
          "index"
          "pager"
        ];
      }
      {
        key = "\\CL";
        action = "sidebar-prev";
        map = [
          "index"
          "pager"
        ];
      }
      {
        key = "\\CP";
        action = "sidebar-open";
        map = [
          "index"
          "pager"
        ];
      }
      {
        key = "<Enter>";
        action = "display-message";
        map = [ "index" ];
      }
      {
        key = "\\CV";
        action = "display-message";
        map = [ "index" ];
      }
    ];
    extraConfig = ''
      virtual-mailboxes "To Do" "notmuch://?query=tag:todo"
      virtual-mailboxes "To Read" "notmuch://?query=tag:toread"
      virtual-mailboxes "Blocked" "notmuch://?query=tag:blocked"
      virtual-mailboxes "Archive" "notmuch://?query=tag:archive"
      macro index,pager A "<modify-labels-then-hide>+archive -unread -inbox\n"
      bind index,pager y modify-labels
      set mailcap_path = ${mailcap}
      set send_charset="utf-8"
      set edit_headers=yes
      set use_8bit_mime=yes
    '';
    sidebar.enable = true;
  };
  programs.notmuch = {
    enable = true;
    hooks.postNew = ''
      ${lib.getExe pkgs.afew} --tag --new
    '';
  };
}
