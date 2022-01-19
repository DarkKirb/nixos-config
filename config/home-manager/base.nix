{ pkgs, ... }: {
  imports = [
    ../programs/zsh.nix
    ../programs/vim.nix
    ../programs/mail.nix
  ];
  programs = {
    zsh = {
      oh-my-zsh = {
        enable = true;
      };
      initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    };
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  accounts.email.accounts = rec {
    darkkirb = {
      address = "darkkirb@darkkirb.de";
      aliases = [ "postmaster@darkkirb.de" ];
      gpg = {
        encryptByDefault = true;
        key = "3CEF5DDA915AECB0";
        signByDefault = true;
      };
      imap.host = "mail.darkkirb.de";
      imapnotify = {
        enable = true;
        boxes = [ "Inbox" ];
        onNotify = "${pkgs.isync}/bin/mbsync %s";
        onNotifyPost = {
          mail = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
        };
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
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/darkkirb@darkkirb.de";
      realName = "Charlotte 🦝 Delenk";
      signature.text = ''
        --
        Charlotte

        https://darkkirb.de • GPG Key 3CEF 5DDA 915A ECB0 • https://keybase.io/darkkirb

        This message was sent from an old email address. My new email address is lotte@chir.rs.
        Please update your contacts accordingly
      '';
      signature.showSignature = "append";
      smtp.host = "mail.darkkirb.de";
      userName = "darkkirb@darkkirb.de";
    };
    lotte = darkkirb // {
      address = "lotte@chir.rs";
      aliases = [ "postmaster@chir.rs" ];
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/lotte@chir.rs";
      primary = true;
      signature.text = ''
        --
        Charlotte

        https://darkkirb.de • GPG Key 3CEF 5DDA 915A ECB0 • https://keybase.io/darkkirb
      '';
      signature.showSignature = "append";
      userName = "lotte@chir.rs";
    };
    mdelenk = darkkirb // {
      address = "mdelenk@hs-mittweida.de";
      aliases = [ ];
      gpg = darkkirb.gpg // {
        key = "5130416C797067B6";
      };
      imap.host = "xc.hs-mittweida.de";
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/mdelenk@hs-mittweida.de";
      realName = "Morten Delenk";
      signature.text = ''
        --
        Morten
      '';
      signature.showSignature = "append";
      smtp = {
        host = "xc.hs-mittweida.de";
        port = 587;
        tls.useStartTls = true;
      };
      userName = "mdelenk@hs-mittweida.de";
    };
  };
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      vim = "nvim";
    };
  };
}
