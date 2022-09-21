desktop: {pkgs, ...}: {
  imports = [
    ../programs/zsh.nix
    ../programs/vim
    ../programs/helix
    ../programs/tmux.nix
    ../programs/ssh.nix
    ../programs/taskwarrior.nix
  ];
  programs = {
    zsh = {
      enable = true;
      enableVteIntegration = true;
      oh-my-zsh = {
        enable = true;
      };
      initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        test -n "$KITTY_INSTALLATION_DIR" || export KITTY_INSTALLATION_DIR=${pkgs.kitty}/lib/kitty
        export KITTY_SHELL_INTEGRATION=enabled
        autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
        kitty-integration
        unfunction kitty-integration
      '';
      plugins = [
      ];
    };
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  accounts.email.maildirBasePath = "Data/Maildir";
  programs.mbsync.extraConfig = ''
    FieldDelimiter -
  '';
  accounts.email.accounts = rec {
    lotte = {
      aliases = ["darkkirb@darkkirb.de" "postmaster@darkkirb.de" "postmaster@chir.rs" "postmaster@miifox.net"];
      gpg = {
        encryptByDefault = true;
        key = "B4E3D4801C49EC5E";
        signByDefault = true;
      };
      imap.host = "mail.chir.rs";
      imapnotify = {
        enable = true;
        boxes = ["Inbox"];
        onNotify = "${pkgs.isync}/bin/mbsync -a || true";
        onNotifyPost =
          if desktop
          then "${pkgs.notmuch}/bin/notmuch new && ${pkgs.afew}/bin/afew --tag --new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'"
          else "${pkgs.notmuch}/bin/notmuch new && ${pkgs.afew}/bin/afew --tag --new";
      };
      smtp.host = "mail.chir.rs";
      address = "lotte@chir.rs";
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        remove = "both";
      };
      neomutt.enable = true;
      notmuch.enable = true;
      realName = "Charlotte 🦝 Delenk";
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/lotte@chir.rs";
      primary = true;
      signature.text = ''
        Charlotte

        https://darkkirb.de • GPG Key EF5F 367A 95E0 BFA6 • https://keybase.io/darkkirb
      '';
      signature.showSignature = "append";
      userName = "lotte@chir.rs";
    };
    mdelenk =
      lotte
      // {
        address = "mdelenk@hs-mittweida.de";
        aliases = [];
        gpg =
          lotte.gpg
          // {
            key = "5130416C797067B6";
          };
        imap.host = "xc.hs-mittweida.de";
        mbsync =
          lotte.mbsync
          // {
            extraConfig.account = {
              AuthMechs = "LOGIN";
            };
          };
        passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/mdelenk@hs-mittweida.de";
        realName = "Morten Delenk";
        signature.text = ''
          Morten
        '';
        signature.showSignature = "append";
        smtp = {
          host = "xc.hs-mittweida.de";
          port = 587;
          tls.useStartTls = true;
        };
        userName = "mdelenk@hs-mittweida.de";
        primary = false;
      };
  };
  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };
  home = {
    shellAliases = {
      vim = "nvim";
      cat = "bat";
      less = "bat";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";
      d = "${pkgs.kitty}/bin/kitty +kitten diff";
      hg = "${pkgs.kitty}/bin/kitty +kitten hyperlinked_grep";
    };
    packages = with pkgs; [
      mosh
      yubikey-manager
      yubico-piv-tool
      ripgrep
    ];
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  home.stateVersion = "22.05";
}
