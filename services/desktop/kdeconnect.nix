{ pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  home.persistence.default.directories = [
    ".config/kdeconnect"
  ];
}
