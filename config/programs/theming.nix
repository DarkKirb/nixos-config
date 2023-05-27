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

  fixupImage = instructions:
    pkgs.stdenv.mkDerivation {
      name = "bg.jxl";
      src = pkgs.emptyDirectory;
      nativeBuildInputs = [pkgs.imagemagick];
      buildPhase = ''
        convert ${toString instructions} $out
      '';
      installPhase = "true";
    };

  validBGs = ["${pkgs.lotte-art}/2020-07-24-urbankitsune-bna-ych.jxl" "${pkgs.lotte-art}/2022-05-02-anonfurryartist-giftart.jxl" "${pkgs.lotte-art}/2022-06-21-sammythetanuki-lotteplushpride.jxl"] ++ (map fixupImage prepBGs);
  validBGsNSFW = ["${pkgs.lotte-art}/2021-10-29-butterskunk-lotte-scat-buffet.jxl" "${pkgs.lotte-art}/2022-08-12-deathtoaster-funpit-scat.jxl" "${pkgs.lotte-art}/2022-08-15-deathtoaster-funpit-mud.jxl"] ++ (map fixupImage prepBGsNSFW) ++ validBGs;

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
  bg =
    choose (
      if withNSFW
      then validBGsNSFW
      else validBGs
    )
    seed;

  color = n:
    config.environment.graphical.colors.main."${builtins.toString n}";
  colorD = n:
    config.environment.graphical.colors.disabled."${builtins.toString n}";
  colorI = n:
    config.environment.graphical.colors.inactive."${builtins.toString n}";

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
    params = ["--lighten" "-0.1"];
  };
  environment.graphical.colorschemes.disabled = {
    image = bgPng;
    params = ["--lighten" "-0.2" "--saturate" "-0.5"];
  };
  environment.graphical.colorschemes.inactive = {
    image = bgPng;
    params = ["--lighten" "-0.3"];
  };
  wayland.windowManager.sway.config.output."*".bg = "${bgPng} fill";
  dconf.settings."org/gnome/desktop/interface" = {
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
      name = "Catppuccin-Mocha-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "compact";
        tweaks = ["rimless" "black"];
        variant = "mocha";
      };
    };
  };
  qt = {
    enable = true;
    style = {
      name = "lightly";
      package = pkgs.plasma5Packages.lightly;
    };
  };
  xdg.configFile."qt5ct/colors/Catppuccin-Custom.conf".text = ''
    [ColorScheme]
    active_colors=${color 15}, ${color 0}, #ffa6adc8, #ff9399b2, ${color 1}, #ff6c7086, ${color 15}, ${color 15}, ${color 15}, ${color 0}, ${colorD 0}, #ff7f849c, ${color 8}, ${color 0}, ${color 13}, ${color 5}, ${color 0}, ${color 15}, ${colorI 0}, ${color 5}, #807f849c
    disabled_colors=${colorD 15}, ${colorD 0}, #ffa6adc8, #ff9399b2, ${colorD 1}, #ff6c7086, ${colorD 15}, ${colorD 15}, ${colorD 15}, ${colorD 0}, ${colorD 0}, #ff7f849c, ${colorD 8}, ${colorD 0}, ${colorD 13}, ${colorD 5}, ${colorD 0}, ${colorD 15}, ${colorI 0}, ${colorD 5}, #807f849c
    inactive_colors=${colorI 15}, ${colorI 0}, #ffa6adc8, #ff9399b2, ${colorI 1}, #ff6c7086, ${colorI 15}, ${colorI 15}, ${colorI 15}, ${colorI 0}, ${colorD 0}, #ff7f849c, ${colorI 8}, ${colorI 0}, ${colorI 13}, ${colorI 5}, ${colorI 0}, ${colorI 15}, ${colorI 0}, ${colorI 5}, #807f849c
  '';
  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  nixpkgs.overlays = [
    (super: self: {
      python3 = super.python.override {
        packageOverrides = self: super: {
          python3Packages = self.python3.pkgs;
          catppuccin = super.catppuccin.overrideAttrs (super: {
            patches =
              super.patches
              or []
              ++ [
                (pkgs.writeText "color.patch" ''
                  diff --git a/catppuccin/colour.py b/catppuccin/colour.py
                  index 193eea7..7620cf0 100644
                  --- a/catppuccin/colour.py
                  +++ b/catppuccin/colour.py
                  @@ -43,6 +43,9 @@ class Colour:
                       @classmethod
                       def from_hex(cls, hex_string: str) -> Colour:
                           """Create a colour from hex string."""
                  +        if hex_string.startswith("#"):
                  +            hex_string = hex_string[1:]
                  +
                           if len(hex_string) not in (6, 8):
                               raise ValueError("Hex string must be 6 or 8 characters long.")

                  diff --git a/catppuccin/flavour.py b/catppuccin/flavour.py
                  index aa7df98..4bf849a 100644
                  --- a/catppuccin/flavour.py
                  +++ b/catppuccin/flavour.py
                  @@ -138,30 +138,30 @@ class Flavour:  # pylint: disable=too-many-instance-attributes
                       def mocha() -> "Flavour":
                           """Mocha flavoured Catppuccin."""
                           return Flavour(
                  -            rosewater=Colour(245, 224, 220),
                  -            flamingo=Colour(242, 205, 205),
                  -            pink=Colour(245, 194, 231),
                  -            mauve=Colour(203, 166, 247),
                  -            red=Colour(243, 139, 168),
                  -            maroon=Colour(235, 160, 172),
                  -            peach=Colour(250, 179, 135),
                  -            yellow=Colour(249, 226, 175),
                  -            green=Colour(166, 227, 161),
                  -            teal=Colour(148, 226, 213),
                  -            sky=Colour(137, 220, 235),
                  -            sapphire=Colour(116, 199, 236),
                  -            blue=Colour(137, 180, 250),
                  -            lavender=Colour(180, 190, 254),
                  -            text=Colour(205, 214, 244),
                  +            rosewater=Colour.from_hex("${color 1}"),
                  +            flamingo=Colour.from_hex("${color 2}"),
                  +            pink=Colour.from_hex("${color 3}"),
                  +            mauve=Colour.from_hex("${color 4}"),
                  +            red=Colour.from_hex("${color 5}"),
                  +            maroon=Colour.from_hex("${color 6}"),
                  +            peach=Colour.from_hex("${color 7}"),
                  +            yellow=Colour.from_hex("${color 8}"),
                  +            green=Colour.from_hex("${color 9}"),
                  +            teal=Colour.from_hex("${color 10}"),
                  +            sky=Colour.from_hex("${color 11}"),
                  +            sapphire=Colour.from_hex("${color 12}"),
                  +            blue=Colour.from_hex("${color 13}"),
                  +            lavender=Colour.from_hex("${color 14}"),
                  +            text=Colour.from_hex("${color 15}"),
                               subtext1=Colour(186, 194, 222),
                               subtext0=Colour(166, 173, 200),
                               overlay2=Colour(147, 153, 178),
                               overlay1=Colour(127, 132, 156),
                               overlay0=Colour(108, 112, 134),
                  -            surface2=Colour(88, 91, 112),
                  -            surface1=Colour(69, 71, 90),
                  -            surface0=Colour(49, 50, 68),
                  -            base=Colour(30, 30, 46),
                  -            mantle=Colour(24, 24, 37),
                  -            crust=Colour(17, 17, 27),
                  +            surface2=Colour.from_hex("${color 2}"),
                  +            surface1=Colour.from_hex("${color 1}"),
                  +            surface0=Colour.from_hex("${color 0}"),
                  +            base=Colour.from_hex("${color 0}"),
                  +            mantle=Colour.from_hex("${color 0}"),
                  +            crust=Colour.from_hex("${color 0}"),
                           )

                '')
              ];
          });
        };
      };
    })
  ];

  home.file = {
    ".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Vanilla-DMZ
    '';
  };
  programs.kitty.settings = with theme; {
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
  home.packages = with pkgs; [
    libsForQt5.breeze-icons
    libsForQt5.qt5ct
    vanilla-dmz
    pkgs.plasma5Packages.lightly
  ];

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
  programs.vscode.userSettings = {
    "catppuccin.colorOverrides".all = {
      rosewater = color 1;
      flamingo = color 2;
      pink = color 3;
      mauve = color 4;
      red = color 5;
      maroon = color 6;
      peach = color 7;
      yellow = color 8;
      green = color 9;
      teal = color 10;
      sky = color 11;
      sapphire = color 12;
      blue = color 13;
      lavender = color 14;
      text = color 15;
      base = color 0;
      surface0 = color 0;
      surface1 = color 1;
      surface2 = color 2;
      mantle = color 0;
      crust = color 0;
    };
  };
  systemd.user.services.transparency = {
    Unit = {
      Description = "transparency";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${./transparency.py}";
    };
  };
}
