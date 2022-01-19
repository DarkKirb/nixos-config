{ pkgs, ... }: {
  gtk.enable = true;
  gtk.iconTheme.package = pkgs.numix-icon-theme;
  gtk.iconTheme.name = "Numix Dark";
  gtk.theme.package = pkgs.libsForQt5.breeze-gtk;
  gtk.theme.name = "Breeze Dark";

  # Paraiso (dark) by Chris Kempson
  # Alacritty colors
  programs.alacritty.settings = {
    enable = true;
    colors = {
      # Default Colors
      primary = {
        background = "0x2f1e2e";
        foreground = "0xa39e9b";
      };

      # Normal Colors
      normal = {
        black = "0x2f1e2e";
        red = "0xef6155";
        green = "0x48b685";
        yellow = "0xfec418";
        blue = "0x06b6ef";
        magenta = "0x815ba4";
        cyan = "0x5bc4bf";
        white = "0xa39e9b";
      };

      # Bright Colors
      bright = {
        black = "0x776e71";
        red = "0xef6155";
        green = "0x48b685";
        yellow = "0xfec418";
        blue = "0x06b6ef";
        magenta = "0x815ba4";
        cyan = "0x5bc4bf";
        white = "0xe7e9db";
      };
    };
  };

}
