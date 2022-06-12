{pkgs, ...}: let
  theme = import ../../extra/theme.nix;
in {
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

  programs.kitty.settings = with theme; {
    background = cssColor bg;
    foreground = cssColor fg;
    cursor = cssColor fg;
    selection_background = "#4f414c";
    color0 = cssColor black;
    color1 = cssColor dark-red;
    color2 = cssColor dark-green;
    color3 = cssColor dark-yellow;
    color4 = cssColor dark-blue;
    color5 = cssColor dark-magenta;
    color6 = cssColor dark-cyan;
    color7 = cssColor light-grey;
    color8 = cssColor dark-grey;
    color9 = cssColor red;
    color10 = cssColor green;
    color11 = cssColor yellow;
    color12 = cssColor blue;
    color13 = cssColor magenta;
    color14 = cssColor cyan;
    color15 = cssColor white;
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
