{ pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  home.persistence.default.directories = [
    ".config/kdeconnect"
  ];
}
