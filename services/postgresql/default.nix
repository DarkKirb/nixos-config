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
    enable = true;
    enableJIT = true;
    enableTCPIP = true;
    package = pkgs.postgresql_17_jit;
    authentication = lib.mkForce ''
      local all all           trust
      host  all all 127.0.0.1 scram-sha-256
    '';
  };
  services.postgresqlBackup = {
    compression = "zstd";
    compressionLevel = 19;
    enable = true;
  };
  environment.persistence."/persistent".directories = [
    "${config.postgresql.dataDir}"
    "${config.postgresqlLocation.location}"
  ];
}
