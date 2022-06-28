{pkgs, ...}: {
  home.packages = with pkgs; [
    anki-bin
  ];
  xdg.configFile."gdb/gdbinit".text = "set auto-load safe-path /nix/store";
  services.xsettingsd = {
    enable = true;
    settings = {
      "Gtk/EnableAnimations" = 1;
      "Gtk/DecorationLayout" = "icon:minimize,maximize,close";
      "Gtk/PrimaryButtonWarpsSlider" = 0;
      "Gtk/ToolbarStyle" = 3;
      "Gtk/MenuImages" = 1;
      "Gtk/ButtonImages" = 1;
      "Gtk/CursorThemeSize" = 24;
      "Gtk/CursorThemeName" = "breeze_cursors";
      "Gtk/FontName" = "Noto Sans,  10";
      "Net/IconThemeName" = "breeze-dark";
    };
  };
}
