{ config, systemConfig, ... }:
{
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
  home.persistence.default.directories = [ ".local/state/syncthing" ];
}
