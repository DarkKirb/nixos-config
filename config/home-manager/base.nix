desktop: {
  pkgs,
  system,
  lib,
  config,
  ...
}: {
  imports =
    [
      (import ../programs/zsh.nix desktop)
      ../programs/tmux.nix
      (import ../programs/vim desktop)
    ]
    ++ (
      if desktop
      then [
        ../programs/mail.nix
        ../programs/taskwarrior.nix
      ]
      else []
    );
  programs = {
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      initExtra =
        if system != "riscv64-linux"
        then ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

            test -n "$KITTY_INSTALLATION_DIR" || export KITTY_INSTALLATION_DIR=${pkgs.kitty}/lib/kitty
            export KITTY_SHELL_INTEGRATION=enabled
            autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
            kitty-integration
            unfunction kitty-integration
        ''
        else "";

      plugins = [
      ];
    };
    autojump.enable = true;
    jq.enable = true;
    ledger.enable = true;
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  home = {
    shellAliases =
      {
        cat = "bat";
        less = "bat";
      }
      // (
        if system != "riscv64-linux"
        then {
          icat = "${pkgs.kitty}/bin/kitty +kitten icat";
          d = "${pkgs.kitty}/bin/kitty +kitten diff";
          hg = "${pkgs.kitty}/bin/kitty +kitten hyperlinked_grep";
          #ssh = "${pkgs.kitty}/bin/kitty +kitten ssh";
          cargo = "${pkgs.cargo-mommy}/bin/cargo-mommy";
        }
        else {}
      );
    packages = with pkgs;
      [
        mosh
        ripgrep
        gh
        htop
        sops
        progress
        hexyl
        mc
        rclone
        libarchive
        p7zip
        unrar
      ]
      ++ (
        if desktop
        then [
          yubikey-manager
          yt-dlp
          oxipng
          jpegoptim
          #picard
          easytag
          alejandra
          yubico-piv-tool
        ]
        else []
      );
    sessionVariables = if desktop then {
      QT_PLUGIN_PATH = lib.mkForce "\${QT_PLUGIN_PATH}:${config.i18n.inputMethod.package}/${pkgs.qt6.qtbase.qtPluginPrefix}:${pkgs.kdePackages.kimageformats}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    } else {};
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  home.stateVersion = "22.05";
  manual.manpages.enable = false; # broken

  _module.args.withNSFW = false;
}
