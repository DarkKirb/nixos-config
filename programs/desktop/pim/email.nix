{ pkgs, config, ... }:
{
  accounts.email.accounts.lotte = {
    address = "lotte@chir.rs";
    imap.host = "imappro.zoho.eu";
    imapnotify = {
      enable = true;
      onNotify = "${pkgs.isync}/bin/mbsync test-%s";
      onNotifyPost.mail = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
    };
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
    };
    msmtp.enable = true;
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
      "${pkgs.coreutils}/bin/cat"
      config.sops.secrets."accounts/email/accounts/lotte/password".path
    ];
    realName = "Charlotte 🦝 Delenk";
    smtp.host = "smtppro.zoho.eu";
    thunderbird.enable = true;
    userName = "lotte@chir.rs";
    primary = true;
  };
  accounts.email.maildirBasePath = "Data/Maildir";
  sops.secrets."accounts/email/accounts/lotte/password".sopsFile = ./secrets.yaml;
  services.imapnotify.enable = true;
  programs.notmuch.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
  home.persistence.default.directories = [
    ".thunderbird"
  ];
}
