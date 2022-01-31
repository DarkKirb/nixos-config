{ pkgs, ... }: {
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

        export TERM=xterm-256color # for mosh

        if [[ ! $TMUX ]]; then
          # figure out the session to use
          SESSION_NAME="$USER"
          if [[ $SSH_CLIENT ]]; then
            SESSION_NAME="$SESSION_NAME-$(echo $SSH_CLIENT | ${pkgs.gawk}/bin/awk '{print $1}' | sed 's/[\.\:]/_/g')"
          elif [[ $WAYLAND_DISPLAY ]]; then
            SESSION_NAME="$SESSION_NAME-$(${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '.. | select(.focused?) | .rect | "\(.width)x\(.height)"')"
          fi
          ${pkgs.tmux}/bin/tmux attach-session -t "$SESSION_NAME" || ${pkgs.tmux}/bin/tmux new-session -s "$SESSION_NAME"
        fi
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
        onNotify = "${pkgs.isync}/bin/mbsync -a";
        onNotifyPost = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
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
      mbsync = darkkirb.mbsync // {
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
