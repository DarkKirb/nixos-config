{ pkgs, ... }: {
  imports = [
    ../programs/zsh.nix
    ../programs/vim.nix
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
}
