{
  config,
  lib,
  ...
}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = "host  all all fd7a:115c:a1e0:ab12::/64 md5";
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
    port = "1589"
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "postgresql";
      static_configs = [
        {
          targets = [
            "127.0.0.1:1589"
          ];
        }
      ];
    }
  ];

}
