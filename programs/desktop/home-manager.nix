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
  ];
  home.packages = with pkgs; [
    kdePackages.kalk
    kdePackages.kalgebra
    kdePackages.filelight
    kdePackages.ffmpegthumbs
    kdePackages.dolphin-plugins
  ];
}
