{
  pkgs,
  nixos-config,
  systemConfig,
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
    ./development/rust
    ./music
  ];
  home.packages =
    with pkgs;
    [
      libreoffice
      obsidian
    ]
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
  ];
}
