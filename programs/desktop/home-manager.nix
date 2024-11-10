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
  ];
  home.packages = with pkgs; [
    kdePackages.kalk
    kdePackages.kalgebra
    kdePackages.filelight
    kdePackages.ffmpegthumbs
    kdePackages.dolphin-plugins
  ];
  home.persistence.default.directories = [
    ".local/share/kwalletd"
  ];
}
