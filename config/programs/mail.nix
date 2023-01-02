{pkgs, ...}: let
  mailcap = pkgs.writeText "mailcap" ''
    text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
    image/*; ${pkgs.imv}/bin/imv %s
  '';
in {
  accounts.email = {
    accounts = {
      lotte = {
        address = "lotte@chir.rs";
        aliases = ["darkkirb@darkkirb.de"];
        gpg = {
          encryptByDefault = true;
          key = "0xB4E3D4801C49EC5E";
          signByDefault = true;
        };
        imap.host = "mail.chir.rs";
        imapnotify = {
          enable = true;
          boxes = ["Inbox"];
          onNotify = "${pkgs.systemd}/bin/start --user mbsync.service";
        };
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          remove = "both";
        };
        msmtp.enable = true;
        neomutt.enable = true;
        notmuch.enable = true;
        passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/lotte@chir.rs";
        primary = true;
        realName = "Charlotte 🦝 Delenk";
        signature.text = ''
          Charlotte

          @charlotte@akko.chir.rs • https://darkkirb.de • 0xB4E3D4801C49EC5E
        '';
        smtp.host = "mail.chir.rs";
        userName = "lotte@chir.rs";
      };
    };
  };
  services = {
    imapnotify.enable = true;
    mbsync = {
      enable = true;
      frequency = "*:0/15";
      postExec = "${pkgs.notmuch}/bin/notmuch new";
    };
  };

  programs = {
    afew = {
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
    mbsync.enable = true;
    msmtp.enable = true;
    neomutt = {
      enable = true;
      binds = [
        {
          key = "\\CA";
          action = "sidebar-next";
          map = ["index" "pager"];
        }
        {
          key = "\\CL";
          action = "sidebar-prev";
          map = ["index" "pager"];
        }
        {
          key = "\\CP";
          action = "sidebar-open";
          map = ["index" "pager"];
        }
        {
          key = "<Enter>";
          action = "display-message";
          map = ["index"];
        }
        {
          key = "\\CV";
          action = "display-message";
          map = ["index"];
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
    notmuch = {
      enable = true;
      hooks.postNew = ''
        ${pkgs.afew}/bin/afew --tag --new
      '';
    };
  };
}
