{
  pkgs,
  self,
  nixpkgs,
  lib,
  config,
  stylix,
  ...
}:
let
  sfw-bgs = [
    "2020-07-24-urbankitsune-bna-ych"
    "2021-09-15-cloverhare-lotteplush"
    "2022-05-02-anonfurryartist-giftart"
    "2022-06-21-sammythetanuki-lotteplushpride"
    "2022-11-15-wolfsifi-maff-me-leashed"
  ];
  nsfw-bgs = sfw-bgs ++ [
    "2021-10-29-butterskunk-lotte-scat-buffet"
    "2021-11-27-theroguez-lottegassyvore1"
    "2021-12-12-baltnwolf-christmas-diaper-messy"
    "2021-12-12-baltnwolf-christmas-diaper"
    "2022-04-20-cloverhare-mxbatty-maffsie-train-plush"
    "2022-04-20-cloverhare-mxbatty-me-train-maffsie-plush"
    "2022-08-12-deathtoaster-funpit-scat"
    "2022-08-15-deathtoaster-funpit-mud"
    "2022-12-27-rexyi-scatych"
    "2023-03-09-rexyi-voredisposal-ych"
    "2023-08-09-coldquarantine-lotte-eating-trash"
    "2023-08-10-coldquarantine-lotte-eating-trash-diapers"
    "2023-08-20-coldquarantine-lotte-eating-trash-clean"
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
  palette = pkgs.palettes.${bg}.dark;
  bgPng = palette.passthru.img;
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
    ./is-dark.nix
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
            name = if config.isLightTheme then "breeze" else "breeze-dark";
            package = pkgs.kdePackages.breeze;
          };
          gtk.iconTheme = {
            package = pkgs.kdePackages.breeze-icons;
            name = if config.isLightTheme then "breeze" else "breeze-dark";
          };
        }
      else
        { }
    )
    (
      if config.isGraphical && !config.isSway then
        { config, lib, ... }:
        {
          imports = [
            ./konsole.nix
            ./telegram-desktop.nix
            ./discord.nix
          ];
          home.activation.nuke-gtkrc = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
            run rm -f $VERBOSE_ARG $HOME/.gtkrc-2.0
          '';
          home.activation.stylixLookAndFeel = lib.mkForce (lib.hm.dag.entryAfter [ "writeBoundary" ] "");
          systemd.user.services.stylix-look-and-feel = {
            Unit = {
              Description = "Apply stylix look and feel";
              After = [ "plasma-workspace.target" ];
              PartOf = [ "home-manager-activation.service" ];
            };
            Service = {
              Type = "oneshot";
              RemainAfterExit = "yes";
              ExecStart = pkgs.writeScript "apply-plasma-lookandfeel" ''
                #!${lib.getExe pkgs.bash}
                ${lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-wallpaperimage"} $(${lib.getExe' pkgs.coreutils "readlink"} /etc/profiles/per-user/${config.home.username}/share/wallpapers)/stylix
                ${lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-lookandfeel"} --apply stylix
              '';
            };
            Install.WantedBy = [ "plasma-workspace.target" ];
          };

        }
      else
        { }
    )
  ];

  stylix = {
    inherit (pkgs) palette-generator;
    enable = true;
    image = bgPng;
    inherit palette;
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
    (
      { config, systemConfig, ... }:
      {
        stylix.targets = {
          kde.enable = systemConfig.isGraphical && !systemConfig.isSway;
        };
      }
    )
  ];
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${bgPng}
      type=image
    '')
  ];
}
