{ pkgs, config, ... }:
{
  accounts.email.accounts.lotte = {
    address = "lotte@chir.rs";
    imap = {
      host = "imappro.zoho.eu";
      port = 993;
    };
    imapnotify = {
      enable = true;
      onNotify = "${pkgs.isync}/bin/mbsync test-%s";
      onNotifyPost = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
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
  programs.notmuch.enable = true;
  programs.neomutt.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
  home.persistence.default.directories = map (f: ".thunderbird/default/${f}") [
    "calendar-data"
    "ImapMail"
    "Mail"
    "settings"
    "storage"
  ];
  home.persistence.default.files = map (f: ".thunderbird/default/${f}") [
    "abook.sqlite"
    "blist.sqlite"
    "content-prefs.sqlite"
    "cookies.sqlite"
    "extension-preferences.json"
    "extensions.json"
    "favicons.sqlite"
    "folderTree.json"
    "formhistory.sqlite"
    "global-messages-db.sqlite"
    "history.sqlite"
    "key4.db"
    "logins.json"
    "mailViews.dat"
    "openpgp.sqlite"
    "permissions.sqlite"
    "places.sqlite"
    "prefs.js"
    "storage.sqlite"
    "virtualFolders.dat"
  ];
}
