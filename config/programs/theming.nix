{ pkgs, ... }:
let theme = import ../../extra/theme.nix; in
{
  gtk.enable = true;
  gtk.iconTheme.package = pkgs.numix-icon-theme;
  gtk.iconTheme.name = "Numix";
  gtk.theme.package = pkgs.libsForQt5.breeze-gtk;
  gtk.theme.name = "Breeze-Dark";
  qt.enable = true;
  qt.style.package = pkgs.libsForQt5.breeze-qt5;
  qt.style.name = "BreezeDark";
}
