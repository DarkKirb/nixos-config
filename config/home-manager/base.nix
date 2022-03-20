desktop: { pkgs, ... }: {
  imports = [
    ../programs/zsh.nix
    ../programs/vim.nix
    ../programs/mail.nix
    ../programs/tmux.nix
  ];
  programs = {
    zsh = {
      oh-my-zsh = {
        enable = true;
      };
      initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        if [[ ! $TMUX ]]; then
          # figure out the session to use
          SESSION_NAME="$USER"
          if [[ $SSH_CLIENT ]]; then
            SESSION_NAME="$SESSION_NAME-$(echo $SSH_CLIENT | ${pkgs.gawk}/bin/awk '{print $1}' | sed 's/[\.\:]/_/g')"
            ${if desktop then ''elif [[ $WAYLAND_DISPLAY ]]; then
            SESSION_NAME="$SESSION_NAME-$(${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '.. | select(.focused?) | .rect | "\(.width)x\(.height)"')"'' else ""}
          fi
          ${pkgs.tmux}/bin/tmux attach-session -t "$SESSION_NAME" || ${pkgs.tmux}/bin/tmux new-session -s "$SESSION_NAME"
        fi
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export GTK_IM_MODULE=ibus
        export QT_IM_MODULE=ibus
        export XMODIFIERS=@im=ibus
      '';
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  accounts.email.maildirBasePath = "Data/Maildir";
  accounts.email.accounts = rec {
    lotte = {
      aliases = [ "darkkirb@darkkirb.de" "postmaster@darkkirb.de" "postmaster@chir.rs" "postmaster@miifox.net" ];
      gpg = {
        encryptByDefault = true;
        key = "B4E3D4801C49EC5E";
        signByDefault = true;
      };
      imap.host = "mail.chir.rs";
      imapnotify = {
        enable = true;
        boxes = [ "Inbox" ];
        onNotify = "${pkgs.isync}/bin/mbsync -a || true";
        onNotifyPost = if desktop then "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'" else "${pkgs.notmuch}/bin/notmuch new";
      };
      smtp.host = "mail.chir.rs";
      address = "lotte@chir.rs";
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        remove = "both";
      };
      msmtp.enable = true;
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
    mdelenk = lotte // {
      address = "mdelenk@hs-mittweida.de";
      aliases = [ ];
      gpg = lotte.gpg // {
        key = "5130416C797067B6";
      };
      imap.host = "xc.hs-mittweida.de";
      mbsync = lotte.mbsync // {
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
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      vim = "nvim";
      cat = "bat";
      less = "bat";
    };
    packages = with pkgs; [
      mosh
      yubikey-manager
      yubico-piv-tool
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
}
