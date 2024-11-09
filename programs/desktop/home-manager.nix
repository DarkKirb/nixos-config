{ pkgs, nixos-config, ... }:
{
  imports = [
    ./firefox
    ./password-manager.nix
    ./syncthing
    ./games
    ./ims.nix
    ./audacious.nix
    "${nixos-config}/services/desktop"
  ];
  home.packages = with pkgs; [
    kdePackages.kontact
    kdePackages.kmail-account-wizard
    kdePackages.kdepim-runtime
    kdePackages.kdepim-addons
    kdePackages.kalk
    kdePackages.kalgebra
    kdePackages.filelight
    kdePackages.ffmpegthumbs
    kdePackages.dolphin-plugins
  ];

  home.persistence.default.directories = [
    ".local/share/akonadi"
    ".local/share/kontact"
  ];
}
