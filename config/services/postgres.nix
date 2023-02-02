{
  config,
  lib,
  ...
}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = "host  all all fd0d:a262:1fa6:e621::/64 md5";
    settings = {
      shared_preload_libraries = "pg_stat_statements";
      "pg_stat_statements.track" = "all";
    };
  };
  services.postgresqlBackup = {
    enable = true;
    compression = "none"; # the file system and restic both do compression
  };
  services.prometheus.exporters.postgres = {
    enable = true;
    user = "postgres";
    listenAddress = "0.0.0.0";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [9187 5432];
}
