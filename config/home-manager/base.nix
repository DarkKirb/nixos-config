desktop: {pkgs, ...}: {
  imports =
    [
      (import ../programs/zsh.nix desktop)
      ../programs/tmux.nix
      ../programs/taskwarrior.nix
      (import ../programs/vim desktop)
    ]
    ++ (
      if desktop
      then [../programs/mail.nix]
      else []
    );
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
    autojump.enable = true;
    jq.enable = true;
    ledger.enable = true;
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  systemd.user.sessionVariables = {
    EDITOR = "vim";
  };
  home = {
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      cat = "bat";
      less = "bat";
    };
    packages = with pkgs;
      [
        yubico-piv-tool
        ripgrep
        gh
        htop
        sops
        ncdu
        progress
        hexyl
        mc
        rclone
      ]
      ++ (
        if desktop
        then [
          yubikey-manager
          yt-dlp
          oxipng
          jpegoptim
          picard
          easytag
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
