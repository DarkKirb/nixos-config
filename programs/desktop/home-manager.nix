{ pkgs, nixos-config, ... }:
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
  home.packages = with pkgs; [
    kdePackages.kalk
    kdePackages.kalgebra
    kdePackages.filelight
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.dolphin-plugins
    libreoffice
    obsidian
  ];
  home.persistence.default.directories = [
    ".local/share/kwalletd"
  ];
}
