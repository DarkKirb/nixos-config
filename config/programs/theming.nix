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
  programs.helix = {
    settings.theme = "catppuccin";
    themes.catppucchin = {
      # Syntax highlighting
      # -------------------
      "type" = "yellow";

      "constructor" = "sapphire";

      "constant" = "peach";
      "constant.builtin" = "peach";
      "constant.character" = "teal";
      "constant.character.escape" = "pink";

      "string" = "green";
      "string.regexp" = "peach";
      "string.special" = "blue";

      "comment" = {
        fg = "surface2";
        modifiers = ["italic"];
      };

      "variable" = "text";
      "variable.parameter" = {
        fg = "maroon";
        modifiers = ["italic"];
      };
      "variable.builtin" = "red";
      "variable.other.member" = "teal";

      "label" = "sapphire"; # used for lifetimes

      "punctuation" = "overlay2";
      "punctuation.special" = "sky";

      "keyword" = "mauve";
      "keyword.control.conditional" = {
        fg = "mauve";
        modifiers = ["italic"];
      };

      "operator" = "sky";

      "function" = "blue";
      "function.builtin" = "peach";
      "function.macro" = "mauve";

      "tag" = "mauve";

      "namespace" = {
        fg = "blue";
        modifiers = ["italic"];
      };

      "special" = "blue"; # fuzzy highlight

      "markup.heading.marker" = {
        fg = "peach";
        modifiers = ["bold"];
      };
      "markup.heading.1" = "lavender";
      "markup.heading.2" = "mauve";
      "markup.heading.3" = "green";
      "markup.heading.4" = "yellow";
      "markup.heading.5" = "pink";
      "markup.heading.6" = "teal";
      "markup.list" = "mauve";
      "markup.bold" = {modifiers = ["bold"];};
      "markup.italic" = {modifiers = ["italic"];};
      "markup.link.url" = {
        fg = "rosewater";
        modifiers = ["italic" "underlined"];
      };
      "markup.link.text" = "blue";
      "markup.raw" = "flamingo";

      "diff.plus" = "green";
      "diff.minus" = "red";
      "diff.delta" = "blue";

      # User Interface
      # --------------
      "ui.background" = {
        fg = "text";
        bg = "base";
      };

      "ui.linenr" = {fg = "surface1";};
      "ui.linenr.selected" = {fg = "lavender";};

      "ui.statusline" = {
        fg = "text";
        bg = "mantle";
      };
      "ui.statusline.inactive" = {
        fg = "surface2";
        bg = "mantle";
      };
      "ui.statusline.normal" = {
        fg = "base";
        bg = "lavender";
        modifiers = ["bold"];
      };
      "ui.statusline.insert" = {
        fg = "base";
        bg = "green";
        modifiers = ["bold"];
      };
      "ui.statusline.select" = {
        fg = "base";
        bg = "flamingo";
        modifiers = ["bold"];
      };

      "ui.popup" = {
        fg = "text";
        bg = "surface0";
      };
      "ui.window" = {fg = "crust";};
      "ui.help" = {
        fg = "overlay2";
        bg = "surface0";
      };

      "ui.bufferline" = {
        fg = "surface1";
        bg = "mantle";
      };
      "ui.bufferline.active" = {
        fg = "text";
        bg = "base";
        modifiers = ["bold" "italic"];
      };
      "ui.bufferline.background" = {bg = "surface0";};

      "ui.text" = "text";
      "ui.text.focus" = {
        fg = "text";
        bg = "surface0";
        modifiers = ["bold"];
      };

      "ui.virtual" = "overlay0";
      "ui.virtual.ruler" = {bg = "surface0";};
      "ui.virtual.indent-guide" = "surface0";

      "ui.selection" = {bg = "surface1";};

      "ui.cursor" = {
        fg = "base";
        bg = "secondary_cursor";
      };
      "ui.cursor.primary" = {
        fg = "base";
        bg = "rosewater";
      };
      "ui.cursor.match" = {
        fg = "peach";
        modifiers = ["bold"];
      };

      "ui.cursorline.primary" = {bg = "cursorline";};

      "ui.highlight" = {
        bg = "surface1";
        modifiers = ["bold"];
      };

      "ui.menu" = {
        fg = "overlay2";
        bg = "surface0";
      };
      "ui.menu.selected" = {
        fg = "text";
        bg = "surface1";
        modifiers = ["bold"];
      };

      diagnostic = {modifiers = ["underlined"];};
      "diagnostic.error" = "red";
      "diagnostic.warn" = "yellow";
      "diagnostic.info" = "sky";
      "diagnostic.hint" = "teal";

      error = "red";
      warning = "yellow";
      info = "sky";
      hint = "teal";
      palette = with theme; {
        rosewater = cssColor rosewater;
        flamingo = cssColor flamingo;
        pink = cssColor pink;
        mauve = cssColor mauve;
        red = cssColor red;
        maroon = cssColor maroon;
        peach = cssColor peach;
        yellow = cssColor yellow;
        green = cssColor green;
        teal = cssColor teal;
        sky = cssColor sky;
        sapphire = cssColor sapphire;
        blue = cssColor blue;
        lavender = cssColor lavender;
        text = cssColor text;
        subtext1 = cssColor subtext1;
        subtext0 = cssColor subtext0;
        overlay2 = cssColor overlay2;
        overlay1 = cssColor overlay1;
        overlay0 = cssColor overlay0;
        surface2 = cssColor surface2;
        surface1 = cssColor surface1;
        surface0 = cssColor surface0;
        base = cssColor base;
        mantle = cssColor mantle;
        crust = cssColor crust;

        cursorline = "#2a2b3c";
        secondary_cursor = "#b5a6a8";
      };
    };
  };
}
