{pkgs, ...}: let
  theme = import ../../extra/theme.nix;
  inherit (config.lib.formats.rasi) mkLiteral;
  rasiColor = c: mkLiteral (cssColor c);
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

  wayland.windowManager.sway.extraConfig = with theme; ''
    # target                 title                bg               text              indicator             border
    client.focused           ${cssColor pink}     ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor pink}
    client.focused_inactive  ${cssColor mauve}    ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor mauve}
    client.unfocused         ${cssColor mauve}    ${cssColor base} ${cssColor text}  ${cssColor rosewater} ${cssColor mauve}
    client.urgent            ${cssColor peach}    ${cssColor base} ${cssColor peach} ${cssColor overlay0}  ${cssColor peach}
    client.placeholder       ${cssColor overlay0} ${cssColor base} ${cssColor text}  ${cssColor overlay0}  ${cssColor overlay0}
    client.background        ${cssColor base}
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

  programs.rofi.theme = with theme; 
    let element = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    }; in
  {
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
    element-icon = element;
    mode-switcher = element;
    window = {
      height = mkLiteral "360px";
      border = mkLiteral "3px";
      border-color = mkLiteral "@border-col";
      background-color = mkLiteral "@bg-col";
      opacity = 0.9;
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

    element-icon = {
      size = mkLiteral "25px";
    };

    "element selected" = {
      background-color = mkLiteral "@selected-col";
      text-color = mkLiteral "@fg-col2";
    };

    mode-switcher = {
      spacing = 0;
    };

    button = {
      padding = mkLiteral "10px";
      background-color = mkLiteral "@bg-col-light";
      text-color = mkLiteral "@grey";
      vertical-align = 0.5;
      horizontal-align = 0.5;
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
}
