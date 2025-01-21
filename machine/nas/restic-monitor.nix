{ config, ... }:
{
  services.prometheus.exporters.restic = {
    enable = true;
    inherit (config.services.restic.backups.sysbackup) environmentFile repository passwordFile;
    port = 44632;
  };
}
