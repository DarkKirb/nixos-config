desktop: {pkgs, ...}: {
  imports = [
    (import ../programs/zsh.nix desktop)
    (import ../programs/helix desktop)
    ../programs/tmux.nix
    ../programs/ssh.nix
    ../programs/taskwarrior.nix
    ../programs/mail.nix
  ];
  programs = {
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      plugins = [
      ];
    };
    atuin.enable = true;
    autojump.enable = true;
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
    };
    packages = with pkgs;
      [
        yubico-piv-tool
        ripgrep
        jq
        gh
        htop
        sops
        ncdu
        progress
        hexyl
      ]
      ++ (
        if desktop
        then [
          yubikey-manager
          yt-dlp
          oxipng
          jpegoptim
        ]
        else []
      );
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
