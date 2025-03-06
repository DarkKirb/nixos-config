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
    "2021-06-20-sammythetanuki-skonks-colored"
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
    "2023-04-03-sibyl-lottehosesuit"
    "2023-04-03-sibyl-lottehosesuit-edited"
    "2023-04-16-baltnwolf-lottediaperplushies"
    "2023-04-16-baltnwolf-lottediaperplushies-messy"
    "2023-08-09-coldquarantine-lotte-eating-trash"
    "2023-08-10-coldquarantine-lotte-eating-trash-diapers"
    "2023-08-20-coldquarantine-lotte-eating-trash-clean"
    "2023-10-31-zombineko-lotteplushpunished-blowout"
    "2023-10-31-zombineko-lotteplushpunished-messier"
    "2023-10-31-zombineko-lotteplushpunished-messier-nodiaper"
    "2023-10-31-zombineko-lotteplushpunished-messy"
    "2023-10-31-zombineko-lotteplushpunished-messy-nodiaper"
    "2023-10-31-zombineko-lotteplushpunished-outside"
    "2025-01-24-crepes-lottediaperpail-tp"
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
  bg = choose (if config.system.isNSFW then nsfw-bgs else sfw-bgs) seed;
  palette = pkgs.palettes.${bg}.${config.polarity};
  bgPng = palette.passthru.img;
in
{
  imports = [
    stylix.nixosModules.stylix
    ./is-dark.nix
  ];
  stylix.targets.qt.enable = lib.mkForce config.system.isGraphical;
  home-manager.users.root.stylix.targets.kde.enable = lib.mkForce false;
  home-manager.users.root.stylix.targets.qt.enable = lib.mkForce false;
  home-manager.users.root.stylix.targets.gnome-text-editor.enable = lib.mkForce false;
  home-manager.users.darkkirb.imports = [
    {
      stylix.targets.kde.enable = lib.mkForce (config.system.isGraphical && (config.system.wm == "kde"));
      stylix.targets.qt.enable = lib.mkForce config.system.isGraphical;
      stylix.targets.gnome-text-editor.enable = false;
    }
    (
      if config.system.isGraphical && (config.system.wm == "kde") then
        { config, lib, ... }:
        {
          imports = [
            ./konsole.nix
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
    ./telegram-desktop.nix
    ./discord.nix
  ];

  stylix = {
    polarity = if config.isLightTheme then "light" else "dark";
    inherit (pkgs) palette-generator;
    enable = true;
    image = bgPng;
    inherit palette;
    cursor = {
      package = if config.system.isGraphical then pkgs.kdePackages.breeze-icons else pkgs.emptyDirectory;
      name = "Breeze";
    };
    fonts = {
      serif = {
        package = if config.system.isGraphical then pkgs.noto-fonts else pkgs.emptyDirectory;
        name = "Noto Serif";
      };
      sansSerif = {
        package = if config.system.isGraphical then pkgs.noto-fonts else pkgs.emptyDirectory;
        name = "Noto Sans";
      };
      monospace = {
        package = if config.system.isGraphical then pkgs.nerd-fonts.fira-code else pkgs.emptyDirectory;
        name = "FiraCode Nerd Font Mono";
      };
      emoji = {
        package = if config.system.isGraphical then pkgs.noto-fonts-emoji else pkgs.emptyDirectory;
        name = "Noto Color Emoji";
      };
    };
  };
  home-manager.sharedModules = [
    (
      {
        config,
        systemConfig,
        lib,
        ...
      }:
      {
        stylix.targets = {
          kde.enable = systemConfig.system.isGraphical && (systemConfig.system.wm == "kde");
          xresources.enable = systemConfig.system.isGraphical;
        };
      }
    )
    (
      if config.system.isGraphical then
        { }
      else
        {
          xresources = {
            extraConfig = lib.mkForce "";
            path = lib.mkForce null;
            properties = lib.mkForce null;
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
    (pkgs.runCommand "pfp" { } ''
      mkdir -pv $out/share/sddm/faces
      ln -s ${
        config.home-manager.users.darkkirb.home.file.".face.icon".source
      } $out/share/sddm/faces/darkkirb.face.icon
    '')
  ];
}
