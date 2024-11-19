{ config, ... }:
{
  services.pgbouncer = {
    enable = true;
    settings = {
      pgbouncer = {
        listen_addr = "localhost";
        auth_type = "scram-sha-256";
        auth_file = config.sops.secrets."services/pgbouncer/settings/pgbouncer/auth".path;
      };
    };
  };
  sops.secrets."services/pgbouncer/settings/pgbouncer/auth".sopsFile = ./${config.networking.hostName}.yaml;
}
