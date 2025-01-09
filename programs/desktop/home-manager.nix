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
  ];
  home.packages =
    with pkgs;
    [
      libreoffice
      gimp
      ffmpeg-full
      darktable
    ]
    ++ (if system == "x86_64-linux" then [ obsidian ] else [ ])
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
    "Unload"
  ];
}
