{pkgs, ...}: let
  theme = import ../../extra/theme.nix;
in {
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
      size = 24;
    };
    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze-Dark";
    };
  };
  qt.enable = true;
  qt.style.package = pkgs.libsForQt5.breeze-qt5;
  qt.style.name = "BreezeDark";
  # Taken from https://github.com/jakehamilton/dotfiles/blob/master/waybar/style.css
  programs.waybar.style = with theme; ''
    * {
      border: none;
    	border-radius: 0;
    	font-size: 14px;
    	min-height: 24px;
      font-family: "NotoSansDisplay Nerd Font", "Noto Sans Mono CJK JP";
      color: ${cssColor base};
    }

    window#waybar {
      background: tranparent;
      opacity: 0.9;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      margin-top: 8px;
      padding: 0px 16px 0px 16px;
      border-radius: 24px;
      transition: none;
      background: transparent;
    }

    #workspaces {
    	margin-top: 8px;
    	margin-left: 12px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	background: ${cssColor surface0};
    	transition: none;
    }

    #workspaces button {
    	transition: none;
    	background: transparent;
    	font-size: 16px;
      color: ${cssColor text};
    }

    #workspaces button.focused {
      background: ${cssColor mauve};
      color: ${cssColor base};
    }

    #workspaces button:hover {
      background: ${cssColor sapphire};
      color: ${cssColor base};
    }

    #mpd {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	background: ${cssColor green};
    	transition: none;
    }

    #mpd.disconnected,
    #mpd.stopped {
    	background: ${cssColor red};
    }

    #network {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${cssColor mauve};
    }

    #pulseaudio {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${cssColor teal};
    }

    #temperature, #battery {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${cssColor green};
    }

    #cpu, #backlight, #battery.warning {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${cssColor yellow};
    }

    #memory, #battery.critical {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${cssColor red};
    }

    #clock {
    	margin-top: 8px;
    	margin-left: 8px;
    	margin-right: 12px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 26px;
    	transition: none;
    	background: ${cssColor surface0};
      color: ${cssColor text};
    }
    
  '';

  programs.foot.settings.colors = with theme; {
    alpha = 0.9;
    background = base;
    foreground = text;
    regular0 = surface1;
    regular1 = red;
    regular2 = green;
    regular3 = yellow;
    regular4 = blue;
    regular5 = pink;
    regular6 = teal;
    regular7 = subtext1;
    bright0 = surface2;
    bright1 = red;
    bright2 = green;
    bright3 = yellow;
    bright4 = blue;
    bright5 = pink;
    bright6 = teal;
    bright7 = subtext0;
  };
}
