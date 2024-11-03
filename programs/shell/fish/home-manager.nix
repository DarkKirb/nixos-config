{pkgs, ...}: {
  programs.fish.enable = true;
  programs.fish.plugins = with pkgs.fishPlugins; [
    tide
  ];
  home.persistence.default.files = [
    ".local/share/fish/fish_history"
  ];
}
