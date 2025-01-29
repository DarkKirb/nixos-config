{
  pkgs,
  config,
  lib,
  ...
}:
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
      onNotify = "${lib.getExe pkgs.isync} test-%s";
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
    notmuch = {
      enable = true;
      neomutt = {
        enable = true;
        virtualMailboxes = [
          {
            name = "Inbox";
            query = "tag:inbox";
          }
        ];
      };
    };
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
  accounts.email.maildirBasePath = "Data/Maildir";
  sops.secrets."accounts/email/accounts/lotte/password".sopsFile = ./secrets.yaml;
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch.enable = true;
  programs.neomutt.enable = true;
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
}
