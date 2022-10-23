desktop: {pkgs, ...}: {
  imports = [
    ../programs/zsh.nix
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

  systemd.user.sessionVariables = {
    EDITOR = "hx";
  };
  home = {
    shellAliases = {
      vi = "hx";
      vim = "hx";
      nvim = "hx";
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
  manual.manpages.enable = false; # broken
}
