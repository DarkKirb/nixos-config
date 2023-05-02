{
  pkgs,
  config,
  colorpickle,
  withNSFW,
  lib,
  self,
  nixpkgs,
  ...
}: let
  theme = import ../../extra/theme.nix;
  inherit (config.lib.formats.rasi) mkLiteral;
  
  prepBGs = [
    ["${pkgs.lotte-art}/2021-01-27-ceeza-lottedonut.jxl" "-crop" "2048x1152+0+106"]
    ["${pkgs.lotte-art}/2021-09-15-cloverhare-lotteplush.jxl" "-crop" "1774x997+0+173"]
    ["${pkgs.lotte-art}/2022-11-15-wolfsifi-maff-me-leashed.jxl" "-crop" "1699x956+0+88"]
  ];

  prepBGsNSFW = [
    ["${pkgs.lotte-art}/2021-11-27-theroguez-lottegassyvore1.jxl" "-crop" "1233x694+0+65"]
    ["${pkgs.lotte-art}/2021-12-12-baltnwolf-christmas-diaper.jxl" "-crop" "2599x1462+0+294"]
    ["${pkgs.lotte-art}/2021-12-12-baltnwolf-christmas-diaper-messy.jxl" "-crop" "2599x1462+0+294"]
    ["${pkgs.lotte-art}/2022-04-20-cloverhare-mxbatty-maffsie-train-plush.jxl" "-crop" "3377x1900+0+211"]
    ["${pkgs.lotte-art}/2022-04-20-cloverhare-mxbatty-me-train-maffsie-plush.jxl" "-crop" "3377x1900+0+211"]
    ["${pkgs.lotte-art}/2022-12-27-rexyi-scatych.jxl" "-crop" "2000x1120+0+0"]
    ["${pkgs.lotte-art}/2023-03-09-rexyi-voredisposal-ych.jxl" "-crop" "2000x1120+0+0"]
    ["${pkgs.lotte-art}/2023-04-16-baltnwolf-lottediaperplushies.jxl" "-gravity" "center" "-background" "white" "-extent" "5333x3000"]
    ["${pkgs.lotte-art}/2023-04-16-baltnwolf-lottediaperplushies-messy.jxl" "-gravity" "center" "-background" "white" "-extent" "5333x3000"]
  ];

  fixupImage = instructions: pkgs.stdenv.mkDerivation {
    name = "bg.jxl";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = [pkgs.imagemagick];
    buildPhase = ''
      convert ${toString instructions} $out
    '';
    installPhase = "true";
  };
  
  validBGs = ["${pkgs.lotte-art}/2020-07-24-urbankitsune-bna-ych.jxl" "${pkgs.lotte-art}/2022-05-02-anonfurryartist-giftart.jxl" "${pkgs.lotte-art}/2022-06-21-sammythetanuki-lotteplushpride.jxl"] ++ (map fixupImage prepBGs);
  validBGsNSFW = ["${pkgs.lotte-art}2021-10-29-butterskunk-lotte-scat-buffet.jxl" "${pkgs.lotte-art}/2022-08-12-deathtoaster-funpit-scat.jxl" "${pkgs.lotte-art}/2022-08-15-deathtoaster-funpit-mud.jxl"] ++ (map fixupImage prepBGsNSFW) ++ validBGs;

  mod = a: b: a - (a / b * b);
  choose = l: rand: let len = builtins.length l; in builtins.elemAt l (mod rand len);
  hexToIntList = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };
  hexToInt = s: lib.foldl (state: new: state * 16 + hexToIntList.${new}) 0 (lib.strings.stringToCharacters s);
  
  seed = hexToInt (self.shortRev or nixpkgs.shortRev);
  bg = choose (if withNSFW then validBGsNSFW else validBGs) seed;

  color = n:
    config.environment.graphical.colors.main."${builtins.toString n}";
  color' = n: mkLiteral (color n);
  bgPng = pkgs.stdenv.mkDerivation {
    name = "bg.png";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = [pkgs.imagemagick];
    buildPhase = ''
      convert ${bg} $out
    '';
    installPhase = "true";
  };
in {
  imports = [
    colorpickle.nixosModules.default
  ];
  environment.graphical.colorschemes.main = {
    image = bgPng;
    #params = ["--lighten" "0.1"];
  };
  wayland.windowManager.sway.config.output."*".bg = "${bgPng} fill";
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
    background_opacity = "0.85";
    background = color 0;
    foreground = color 15;
    cursor = color 15;
    selection_background = "#4f414c";
    color0 = color 0;
    color1 = color 9;
    color2 = color 10;
    color3 = color 11;
    color4 = color 12;
    color5 = color 13;
    color6 = color 14;
    color7 = color 7;
    color8 = color 8;
    color9 = color 9;
    color10 = color 10;
    color11 = color 11;
    color12 = color 12;
    color13 = color 13;
    color14 = color 14;
    color15 = color 15;
  };
  # Taken from https://github.com/jakehamilton/dotfiles/blob/master/waybar/style.css
  programs.waybar.style = with theme; ''
    * {
      border: none;
    	border-radius: 0;
    	font-size: 14px;
    	min-height: 24px;
      font-family: "NotoSansDisplay Nerd Font", "Noto Sans Mono CJK JP";
      color: ${color 0};
    }

    window#waybar {
      background: transparent;
      color: ${color 15};
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
    	background-color: ${color 0};
        color: ${color 15};
    	transition: none;
    }

    #workspaces button {
    	transition: none;
    	background: transparent;
    	font-size: 16px;
      color: ${color 15};
    }

    #workspaces button.focused {
      background: ${color 13};
      color: ${color 0};
    }

    #workspaces button:hover {
      background: ${color 10};
      color: ${color 0};
    }

    #mpd {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	background: ${color 2};
    	transition: none;
    }

    #mpd.disconnected,
    #mpd.stopped {
    	background: ${color 4};
    }

    #network {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${color 13};
    }

    #pulseaudio {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${color 11};
    }

    #temperature, #battery {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${color 2};
    }

    #cpu, #backlight, #battery.warning {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${color 14};
    }

    #memory, #battery.critical {
    	margin-top: 8px;
    	margin-left: 8px;
    	padding-left: 16px;
    	padding-right: 16px;
    	margin-bottom: 0;
    	border-radius: 24px;
    	transition: none;
    	background: ${color 12};
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
    	background: ${color 0};
      color: ${color 15};
    }
  '';

  wayland.windowManager.sway.extraConfig = with theme; ''
    # target                 title                bg               text              indicator             border
    client.focused           ${color 5}     ${color 0} ${color 15}  ${color 12} ${color 5}
    client.focused_inactive  ${color 13}    ${color 0} ${color 15}  ${color 12} ${color 13}
    client.unfocused         ${color 13}    ${color 0} ${color 15}  ${color 12} ${color 13}
    client.urgent            ${color 14}    ${color 0} ${color 14} ${color 8}  ${color 14}
    client.placeholder       ${color 8} ${color 0} ${color 15}  ${color 8}  ${color 8}
    client.background        ${color 0}
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
      bg-col = color' 0;
      bg-col-light = color' 0;
      border-col = color' 0;
      selected-col = color' 0;
      blue = color' 1;
      fg-col = color' 15;
      fg-col2 = color' 12;
      grey = color' 8;
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
