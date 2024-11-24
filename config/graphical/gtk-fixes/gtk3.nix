{ ... }:
{
  gtk.gtk3 = {
    extraConfig = {
      gtk-decoration-layout = "menu:close";
    };
    extraCss = ''
      .window-frame, .window-frame:backdrop {
        box-shadow: 0 0 0 black;
        border-style: none;
        margin: 0;
        border-radius: 0;
      }

      .titlebar {
        border-radius: 0;
      }

      .window-frame.csd.popup {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(0, 0, 0, 0.13);
      }

      .header-bar {
        background-image: none;
        background-color: #ededed;
        box-shadow: none;
      }
      GtkLabel.title {
        opacity: 0;
      }
    '';
  };
  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
    GDK_DEBUG = "portals"; # sigh…
  };
}
