{pkgs, ...}: {
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
    ];
  };
  home.persistence.default.files = [
    ".local/share/fish/fish_history"
  ];
}
