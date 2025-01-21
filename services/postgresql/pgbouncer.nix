{ config, lib, ... }:
{
  services.pgbouncer = {
    enable = config.services.postgresql.enable;
    settings = {
      pgbouncer = {
        listen_addr = "*";
        auth_type = "scram-sha-256";
        auth_file = config.sops.secrets."services/pgbouncer/settings/pgbouncer/auth".path;
        ignore_startup_parameters = "extra_float_digits";
        stats_users = "stats_collector";
      };
    };
  };
  sops.secrets."services/pgbouncer/settings/pgbouncer/auth" =
    lib.mkIf config.services.postgresql.enable
      {
        sopsFile = ./${config.networking.hostName}.yaml;
        owner = "pgbouncer";
      };
  sops.secrets."services/prometheus/exporters/pgbouncer/connectionEnv" =
    lib.mkIf config.services.postgresql.enable
      {
        sopsFile = ./${config.networking.hostName}.yaml;
        #owner = config.services.prometheus.exporters.pgbouncer.user;
      };
  services.prometheus.exporters.pgbouncer = {
    enable = config.services.postgresql.enable;
    port = 29714;
    connectionEnvFile =
      config.sops.secrets."services/prometheus/exporters/pgbouncer/connectionEnv".path;
  };
  services.postgresql.ensureUsers = lib.mkIf config.services.postgresql.enable [
    {
      name = "stats_collector";
    }
  ];
}
