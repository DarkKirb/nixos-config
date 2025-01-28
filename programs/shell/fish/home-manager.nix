{ pkgs, config, ... }:
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
    ".local/share/direnv"
    ".local/share/fish"
  ];
  programs.nix-index.enable = true;
  programs.direnv.enable = true;
  xdg.dataFile."fish/home-manager_generated_completions".enable = false;
  systemd.user.tmpfiles.rules = [
    "L /persistent${config.xdg.dataHome}/fish/home-manager_generated_completions - - - - ${
      config.xdg.dataFile."fish/home-manager_generated_completions".source
    }"
  ];
}
