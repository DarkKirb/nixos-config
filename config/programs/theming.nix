{ pkgs, ... }:
let theme = import ../../extra/theme.nix; in
{
  gtk = {
    enable = true;
    cursorTheme = {
      package = null;
      name = "breeze_cursors";
      size = 24;
    };
    font = {
      package = null;
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      package = null;
      name = "breeze-dark";
    };
    theme = {
      package = null;
      name = "Breeze-Dark";
    };
  };
  qt.enable = true;
  qt.style.package = pkgs.libsForQt5.breeze-qt5;
  qt.style.name = "BreezeDark";
}
