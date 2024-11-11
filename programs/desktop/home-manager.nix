{ pkgs, nixos-config, ... }:
{
  imports = [
    ./firefox
    ./password-manager.nix
    ./syncthing
    ./games
    ./ims.nix
    ./audacious.nix
    ./pim.nix
    "${nixos-config}/services/desktop"
    ./kodi
    ./pim
  ];
  home.packages = with pkgs; [
    kdePackages.kalk
    kdePackages.kalgebra
    kdePackages.filelight
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.dolphin-plugins
  ];
  home.persistence.default.directories = [
    ".local/share/kwalletd"
  ];
}
