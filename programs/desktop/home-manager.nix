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
      anki
    ]
    ++ (
      if system == "x86_64-linux" then
        [
          obsidian
          nicotine-plus
          ausweisapp
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
    ".config/nicotine"
    ".config/MusicBrainz"
    "Unload"
    ".local/share/Anki2"
  ];
}
