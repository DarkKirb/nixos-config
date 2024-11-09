{pkgs, ...}: {
  home.packages = with pkgs; [audacious];
  home.persistence.default.directory = [
    ".config/audacious"
  ];
}
