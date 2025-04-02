{
  pkgs,
  systemConfig,
  system,
  ...
}:
{
  imports = [
    ./firefox
    ./password-manager.nix
    ./syncthing
    ./games
    ./ims.nix
    ../../services/desktop
    ./kodi
    ./pim
    ./development
    ./music
    ./i18n.nix
  ];
  home.packages =
    with pkgs;
    [
      gimp
      ffmpeg-full
      darktable
      digikam
    ]
    ++ (
      if system == "x86_64-linux" then
        [
          obsidian
          qgis
          nicotine-plus
        ]
      else
        [ ]
    )
    ++ (
      if systemConfig.system.wm == "kde" then
        with pkgs;
        [
          kdePackages.kalk
          kdePackages.kalgebra
          kdePackages.filelight
          kdePackages.kdegraphics-thumbnailers
          kdePackages.ffmpegthumbs
          kdePackages.dolphin-plugins
        ]
      else
        [ ]
    );
  home.persistence.default.directories = [
    ".local/share/kwalletd"
    ".local/share/darktable"
    ".local/share/digikam"
    ".config/nicotine"
    ".config/MusicBrainz"
    "Unload"
  ];
}
