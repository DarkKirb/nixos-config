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

  # Paraiso (dark) by Chris Kempson
  # Alacritty colors
  programs.alacritty = {
    enable = true;
    settings = {
      colors = with theme; {
        # Default Colors
        primary = {
          background = alacrittyColor bg;
          foreground = alacrittyColor fg;
        };

        # Normal Colors
        normal = {
          black = alacrittyColor black;
          red = alacrittyColor dark-red;
          green = alacrittyColor dark-green;
          yellow = alacrittyColor dark-yellow;
          blue = alacrittyColor dark-blue;
          magenta = alacrittyColor dark-magenta;
          cyan = alacrittyColor dark-cyan;
          white = alacrittyColor light-grey;
        };

        # Bright Colors
        bright = {
          black = alacrittyColor dark-grey;
          red = alacrittyColor red;
          green = alacrittyColor green;
          yellow = alacrittyColor yellow;
          blue = alacrittyColor blue;
          magenta = alacrittyColor magenta;
          cyan = alacrittyColor cyan;
          white = alacrittyColor white;
        };
      };
    };
  };

  programs.waybar.style = with theme; ''
    * {
      border: none;
      border-radius: 0;
      font-family: "NotoSansDisplay Nerd Font", "Noto Sans Mono CJK JP";
    }

    window.HDMI-A-1 * {
      font-size: 12px;
    }

    window#waybar {
      background: ${cssColor bg};
    }

    #mpd, #cpu {
      background: ${cssColor green};
      color: ${cssColor bg};
    }

    #pulseaudio {
      background: ${cssColor yellow};
      color: ${cssColor bg};
    }

    #network, #tray {
      background: ${cssColor blue};
      color: ${cssColor bg};
    }

    #memory, #workspaces button.focused {
      background: ${cssColor magenta};
    }

    #language {
      background: ${cssColor cyan};
    }

    #clock {
      background: ${cssColor light-grey};
    }

    .urgent {
      background: ${cssColor red};
    }

    #workspaces button {
      background: transparent;
    }

    label {
      color: #fff;
    }
  '';
}
