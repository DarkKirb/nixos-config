{pkgs, ...}: {
  home.packages = with pkgs; [kicad-unstable-small];
}
