{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./pgbouncer.nix
  ];
  services.postgresql = {
    enableJIT = true;
    enableTCPIP = true;
    package = pkgs.postgresql_17_jit;
    authentication = lib.mkForce ''
      local all all              peer
      host  all all 127.0.0.1/32 scram-sha-256
    '';
  };
  services.postgresqlBackup = {
    compression = "zstd";
    compressionLevel = 19;
    enable = config.services.postgresql.enable;
  };
  environment.persistence."/persistent".directories = lib.mkIf config.services.postgresql.enable [
    "${config.services.postgresql.dataDir}"
    "${config.services.postgresqlBackup.location}"
  ];
  systemd.services.postgresql.postStart = lib.mkIf config.services.postgresql.enable ''
    for ref in ${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."systemd/services/postgresql/postStart".path
    }; do
      username=$(echo $ref | cut -d= -f1)
      password=$(echo $ref | cut -d= -f2)
      ${config.services.postgresql.package}/bin/psql -U postgres -c "ALTER ROLE $username WITH LOGIN PASSWORD '$password';"
    done
  '';
  sops.secrets."systemd/services/postgresql/postStart" = lib.mkIf config.services.postgresql.enable {
    sopsFile = ./${config.networking.hostName}.yaml;
  };
}
