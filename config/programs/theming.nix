{ pkgs, ... }: {
  gtk.enable = true;
  gtk.iconTheme.package = pkgs.numix-icon-theme;
  gtk.iconTheme.name = "Numix Dark";
  gtk.theme.package = pkgs.libsForQt5.breeze-gtk;
  gtk.theme.name = "Breeze Dark";
}
