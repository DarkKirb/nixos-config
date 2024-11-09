{ pkgs, ... }:
{
  imports = [
    ./tide.nix
    ./z.nix
  ];
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "fzf";
        src = fzf.src;
      }
    ];
  };
  home.persistence.default.directories = [
    ".local/share/fish"
  ];
  programs.nix-index.enable = true;
  programs.direnv.enable = true;
}
