{
  pkgs,
  nixos-config,
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
    "${nixos-config}/services/desktop"
    ./kodi
    ./pim
    ./development
    ./music
    ./i18n.nix
  ] ++ (if system == "x86-64-linux" then [ ./texlive.nix ] else [ ]);
  home.packages =
    with pkgs;
    [
      libreoffice
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
        ]
      else
        [ ]
    )
    ++ (
      if !systemConfig.isSway then
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
    "Unload"
  ];
}
