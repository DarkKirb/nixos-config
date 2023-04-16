{
  pkgs,
  config,
  ...
}: let
  theme = import ../../extra/theme.nix;
  inherit (config.lib.formats.rasi) mkLiteral;
  rasiColor = c: mkLiteral (theme.cssColor c);
in {
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "Breeze-Dark";
    icon-theme = "breeze-dark";
    cursor-theme = "Vanilla-DMZ";
  };
  gtk = {
    enable = true;
    gtk2.extraConfig = ''
      gtk-cursor-theme-name = "Vanilla-DMZ"
      gtk-cursor-theme-size = 0
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Vanilla-DMZ";
      gtk-cursor-theme-size = 0;
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
  qt = {
    enable = true;
    style = {
      name = "Breeze";
      package = pkgs.libsForQt5.breeze-qt5;
    };
  };
  home.file = {
    ".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Vanilla-DMZ
    '';
  };
  programs.kitty.settings = with theme; {
    background_opacity = "0.9";
    background = cssColor base;
    foreground = cssColor text;
    cursor = cssColor text;
    selection_background = "#4f414c";
    color0 = cssColor surface1;
    color1 = cssColor red;
    color2 = cssColor green;
    color3 = cssColor yellow;
    color4 = cssColor blue;
    color5 = cssColor pink;
    color6 = cssColor teal;
    color7 = cssColor subtext1;
    color8 = cssColor surface2;
    color9 = cssColor red;
    color10 = cssColor green;
    color11 = cssColor yellow;
    color12 = cssColor blue;
    color13 = cssColor pink;
    color14 = cssColor teal;
    color15 = cssColor subtext0;
  };
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
      background: transparent;
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

  wayland.windowManager.sway.extraConfig = with theme; ''
    # target                 title                bg               text              indicator             border
    client.focused           ${cssColor pink}     ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor pink}
    client.focused_inactive  ${cssColor mauve}    ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor mauve}
    client.unfocused         ${cssColor mauve}    ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor mauve}
    client.urgent            ${cssColor peach}    ${cssColor base} ${cssColor peach} ${cssColor overlay0}  ${cssColor peach}
    client.placeholder       ${cssColor overlay0} ${cssColor base} ${cssColor text}  ${cssColor overlay0}  ${cssColor overlay0}
    client.background        ${cssColor base}
    seat seat0 xcursor_theme breeze-dark 24
  '';
  home.packages = with pkgs; [libsForQt5.breeze-icons libsForQt5.qt5ct vanilla-dmz];

  programs.rofi.theme = with theme; let
    element = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
  in {
    "*" = {
      bg-col = rasiColor base;
      bg-col-light = rasiColor base;
      border-col = rasiColor base;
      selected-col = rasiColor base;
      blue = rasiColor blue;
      fg-col = rasiColor text;
      fg-col2 = rasiColor red;
      grey = rasiColor overlay0;
      width = 600;
    };
    element-text = element;
    window = {
      height = mkLiteral "360px";
      border = mkLiteral "3px";
      border-color = mkLiteral "@border-col";
      background-color = mkLiteral "@bg-col";
      opacity = mkLiteral "0.9";
    };
    mainbox = {
      background-color = mkLiteral "@bg-col";
    };
    inputbar = {
      children = map mkLiteral ["prompt" "entry"];
      background-color = mkLiteral "@bg-col";
      border-radius = mkLiteral "5px";
      padding = mkLiteral "2px";
    };
    prompt = {
      background-color = mkLiteral "@blue";
      padding = mkLiteral "6px";
      text-color = mkLiteral "@bg-col";
      border-radius = mkLiteral "3px";
      margin = mkLiteral "20px 0px 0px 20px";
    };

    textbox-prompt-colon = {
      expand = mkLiteral "false";
      str = ":";
    };

    entry = {
      padding = mkLiteral "6px";
      margin = mkLiteral "20px 0px 0px 10px";
      text-color = mkLiteral "@fg-col";
      background-color = mkLiteral "@bg-col";
    };

    listview = {
      border = mkLiteral "0px 0px 0px";
      padding = mkLiteral "6px 0px 0px";
      margin = mkLiteral "10px 0px 0px 20px";
      columns = 2;
      lines = 5;
      background-color = mkLiteral "@bg-col";
    };

    element = {
      padding = mkLiteral "5px";
      background-color = mkLiteral "@bg-col";
      text-color = mkLiteral "@fg-col";
    };

    element-icon =
      element
      // {
        size = mkLiteral "25px";
      };

    "element selected" = {
      background-color = mkLiteral "@selected-col";
      text-color = mkLiteral "@fg-col2";
    };

    mode-switcher =
      element
      // {
        spacing = 0;
      };

    button = {
      padding = mkLiteral "10px";
      background-color = mkLiteral "@bg-col-light";
      text-color = mkLiteral "@grey";
      vertical-align = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.5";
    };

    "button selected" = {
      background-color = mkLiteral "@bg-col";
      text-color = mkLiteral "@blue";
    };

    message = {
      background-color = mkLiteral "@bg-col-light";
      margin = mkLiteral "2px";
      padding = mkLiteral "2px";
      border-radius = mkLiteral "5px";
    };

    textbox = {
      padding = mkLiteral "6px";
      margin = mkLiteral "20px 0px 0px 20px";
      text-color = mkLiteral "@blue";
      background-color = mkLiteral "@bg-col-light";
    };
  };
  programs.neomutt.extraConfig = ''
    color normal		  default default         # Text is "Text"
    color index		    color2 default ~N       # New Messages are Green
    color index		    color1 default ~F       # Flagged messages are Red
    color index		    color13 default ~T      # Tagged Messages are Red
    color index		    color1 default ~D       # Messages to delete are Red
    color attachment	color5 default          # Attachments are Pink
    color signature	  color8 default          # Signatures are Surface 2
    color search		  color4 default          # Highlighted results are Blue

    color indicator		default color8          # currently highlighted message Surface 2=Background Text=Foreground
    color error		    color1 default          # error messages are Red
    color status		  color15 default         # status line "Subtext 0"
    color tree        color15 default         # thread tree arrows Subtext 0
    color tilde       color15 default         # blank line padding Subtext 0

    color hdrdefault  color13 default         # default headers Pink
    color header		  color13 default "^From:"
    color header	 	  color13 default "^Subject:"

    color quoted		  color15 default         # Subtext 0
    color quoted1		  color7 default          # Subtext 1
    color quoted2		  color8 default          # Surface 2
    color quoted3		  color0 default          # Surface 1
    color quoted4		  color0 default
    color quoted5		  color0 default

    color body		color2 default		[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+               # email addresses Green
    color body	  color2 default		(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+        # URLs Green
    color body		color4 default		(^|[[:space:]])\\*[^[:space:]]+\\*([[:space:]]|$) # *bold* text Blue
    color body		color4 default		(^|[[:space:]])_[^[:space:]]+_([[:space:]]|$)     # _underlined_ text Blue
    color body		color4 default		(^|[[:space:]])/[^[:space:]]+/([[:space:]]|$)     # /italic/ text Blue

    color sidebar_flagged   color1 default    # Mailboxes with flagged mails are Red
    color sidebar_new       color10 default   # Mailboxes with new mail are Green
  '';
  home.file.".local/share/mc/skins/catppuccin.ini".source = ../../extra/mc-catppuccin.ini;
}
