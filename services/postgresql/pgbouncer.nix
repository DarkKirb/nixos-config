{ config, lib, ... }:
{
  services.pgbouncer = {
    enable = config.services.postgresql.enable;
    settings = {
      pgbouncer = {
        listen_addr = "localhost";
        auth_type = "scram-sha-256";
        auth_file = config.sops.secrets."services/pgbouncer/settings/pgbouncer/auth".path;
      };
    };
  };
  sops.secrets."services/pgbouncer/settings/pgbouncer/auth" =
    lib.mkIf config.services.postgresql.enable
      {
        sopsFile = ./${config.networking.hostName}.yaml;
      };
}
