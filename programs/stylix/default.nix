{
  pkgs,
  self,
  nixpkgs,
  lib,
  config,
  system,
  stylix,
  ...
}:
let
  sfw-bgs = [
    "2020-07-24-urbankitsune-bna-ych.jxl"
    "2021-09-15-cloverhare-lotteplush.jxl"
    "2022-05-02-anonfurryartist-giftart.jxl"
    "2022-06-21-sammythetanuki-lotteplushpride.jxl"
    "2022-11-15-wolfsifi-maff-me-leashed.jxl"
  ];
  nsfw-bgs = [
    "2020-07-24-urbankitsune-bna-ych.jxl"
    "2021-09-15-cloverhare-lotteplush.jxl"
    "2021-10-29-butterskunk-lotte-scat-buffet.jxl"
    "2021-11-27-theroguez-lottegassyvore1.jxl"
    "2021-12-12-baltnwolf-christmas-diaper-messy.jxl"
    "2021-12-12-baltnwolf-christmas-diaper.jxl"
    "2022-04-20-cloverhare-mxbatty-maffsie-train-plush.jxl"
    "2022-04-20-cloverhare-mxbatty-me-train-maffsie-plush.jxl"
    "2022-05-02-anonfurryartist-giftart.jxl"
    "2022-06-21-sammythetanuki-lotteplushpride.jxl"
    "2022-08-12-deathtoaster-funpit-scat.jxl"
    "2022-08-15-deathtoaster-funpit-mud.jxl"
    "2022-11-15-wolfsifi-maff-me-leashed.jxl"
    "2022-12-27-rexyi-scatych.jxl"
    "2023-03-09-rexyi-voredisposal-ych.jxl"
    "2023-08-09-coldquarantine-lotte-eating-trash.jxl"
    "2023-08-10-coldquarantine-lotte-eating-trash-diapers.jxl"
    "2023-08-20-coldquarantine-lotte-eating-trash-clean.jxl"
  ];
  mod = a: b: a - (a / b * b);
  choose =
    l: rand:
    let
      len = builtins.length l;
    in
    builtins.elemAt l (mod rand len);
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
  hexToInt =
    s: lib.foldl (state: new: state * 16 + hexToIntList.${new}) 0 (lib.strings.stringToCharacters s);
  seed = hexToInt (self.shortRev or nixpkgs.shortRev);
  bg = choose (if config.isNSFW then nsfw-bgs else sfw-bgs) seed;
  bgPng = pkgs.stdenv.mkDerivation {
    name = "bg.png";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = [ pkgs.imagemagick ];
    buildPhase = ''
      magick ${pkgs.art-lotte}/${bg} $out
    '';
    installPhase = "true";
  };
  qtctPalette = pkgs.writeText "colors.conf" (
    with config.lib.stylix.colors;
    ''
      [ColorScheme]
      active_colors=#ff${base0C}, #ff${base01}, #ff${base01}, #ff${base05}, #ff${base03}, #ff${base04}, #ff${base0E}, #ff${base06}, #ff${base05}, #ff${base01}, #ff${base00}, #ff${base03}, #ff${base02}, #ff${base0E}, #ff${base09}, #ff${base08}, #ff${base02}, #ff${base05}, #ff${base01}, #ff${base0E}, #8f${base0E}
      disabled_colors=#ff${base0F}, #ff${base01}, #ff${base01}, #ff${base05}, #ff${base03}, #ff${base04}, #ff${base0F}, #ff${base0F}, #ff${base0F}, #ff${base01}, #ff${base00}, #ff${base03}, #ff${base02}, #ff${base0E}, #ff${base09}, #ff${base08}, #ff${base02}, #ff${base05}, #ff${base01}, #ff${base0F}, #8f${base0F}
      inactive_colors=#ff${base0C}, #ff${base01}, #ff${base01}, #ff${base05}, #ff${base03}, #ff${base04}, #ff${base0E}, #ff${base06}, #ff${base05}, #ff${base01}, #ff${base00}, #ff${base03}, #ff${base02}, #ff${base0E}, #ff${base09}, #ff${base08}, #ff${base02}, #ff${base05}, #ff${base01}, #ff${base0E}, #8f${base0E}
    ''
  );
in
{
  imports = [
    stylix.nixosModules.stylix
  ];
  home-manager.users.root.stylix.targets.kde.enable = lib.mkForce false;
  home-manager.users.darkkirb.imports = [
    {
      xdg.configFile = {
        "qt5ct/qt5ct.conf".text = lib.generators.toINI { } {
          Appearance = {
            custom_palette = true;
            color_scheme_path = "${qtctPalette}";
            standard_dialogs = "xdgdesktopportal";
            style = "breeze";
          };
        };
        "qt6ct/qt6ct.conf".text = lib.generators.toINI { } {
          Appearance = {
            custom_palette = true;
            color_scheme_path = "${qtctPalette}";
            standard_dialogs = "xdgdesktopportal";
            style = "breeze";
          };
        };
      };
    }
    {
      stylix.targets.kde.enable = lib.mkForce (config.isGraphical && !config.isSway);
    }
    (
      if config.isSway then
        {
          qt.style = {
            name = "breeze-dark";
            package = pkgs.kdePackages.breeze;
          };
          gtk.iconTheme = {
            package = pkgs.kdePackages.breeze-icons;
            name = "breeze-dark";
          };
        }
      else
        { }
    )
    (
      if config.isGraphical && !config.isSway then
        { config, lib, ... }:
        {
          home.activation.nuke-gtkrc = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
            rm $HOME/.gtkrc-2.0 || true
          '';
          home.activation.stylixLookAndFeel = lib.mkForce (lib.hm.dag.entryAfter [ "writeBoundary" ] "");
          systemd.user.services.stylix-look-and-feel = {
            Unit = {
              Description = "Apply stylix look and feel";
              After = [ "plasma-workspace.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = pkgs.writeScript "apply-plasma-lookandfeel" ''
                #!${pkgs.bash}/bin/sh
                ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage /etc/profiles/per-user/${config.home.username}/share/wallpapers/stylix
                ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-lookandfeel --apply stylix
              '';
            };
            Install.WantedBy = [ "plasma-workspace.target" ];
          };
          home.activation.konsolerc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            PATH="${config.home.path}/bin:$PATH:${pkgs.jq}"
            palette=$HOME/.config/stylix/palette.json
            scheme=$HOME/.local/share/konsole/Stylix.colorscheme

            if ! [ -f $palette ]; then
              echo "Palette doesn't exist"
            else
              json=$( cat $palette )

              hex_to_rgb() {
                hex=$1
                r=$((16#''${hex:0:2}))
                g=$((16#''${hex:2:2}))
                b=$((16#''${hex:4:2}))
                echo "$r,$g,$b"
              }

              for base in base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F; do
                hex=$(echo "$json" | jq -r ".$base")
                rgb=$(hex_to_rgb "$hex")
                declare "''${base}_rgb=$rgb"
              done

              mustache_template="
              [Background]
              Color={{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}
              [BackgroundIntense]
              Color={{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}
              [Color0]
              Color={{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}
              [Color0Intense]
              Color={{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}
              [Color1]
              Color={{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}
              [Color1Intense]
              Color={{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}
              [Color2]
              Color={{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}
              [Color2Intense]
              Color={{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}
              [Color3]
              Color={{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}
              [Color3Intense]
              Color={{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}
              [Color4]
              Color={{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}
              [Color4Intense]
              Color={{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}
              [Color5]
              Color={{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}
              [Color5Intense]
              Color={{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}
              [Color6]
              Color={{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}
              [Color6Intense]
              Color={{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}
              [Color7]
              Color={{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}
              [Color7Intense]
              Color={{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}
              [Foreground]
              Color={{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}
              [ForegroundIntense]
              Color={{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}
              [General]
              Description=Stylix
              Opacity=0.75
              Wallpaper=
              "
              populated_template=$(echo "$mustache_template" \
                | sed "s/{{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}/$base00_rgb/g" \
                | sed "s/{{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}/$base03_rgb/g" \
                | sed "s/{{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}/$base08_rgb/g" \
                | sed "s/{{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}/$base0B_rgb/g" \
                | sed "s/{{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}/$base0A_rgb/g" \
                | sed "s/{{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}/$base0D_rgb/g" \
                | sed "s/{{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}/$base0E_rgb/g" \
                | sed "s/{{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}/$base0C_rgb/g" \
                | sed "s/{{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}/$base05_rgb/g" \
                | sed "s/{{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}/$base07_rgb/g")
              echo "$populated_template" > $scheme
            fi

          '';
        }
      else
        { }
    )
  ];

  stylix = {
    enable = system != "riscv64-linux";
    image = bgPng;
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  home-manager.sharedModules = [
    {
      stylix.targets = {
        kde.enable = config.isGraphical && !config.isSway;
      };
    }
  ];
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${bgPng}
      type=image
    '')
  ];
}
