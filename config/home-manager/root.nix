{ pkgs, ... }: {
  imports = [
    ../programs/zsh.nix
  ];
  programs = {
    zsh = {
      oh-my-zsh = {
        enable = true;

      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
        }
      ];
    };
  };
}
