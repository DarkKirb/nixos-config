{
  config,
  pkgs,
  system,
  ...
}:
{
  imports = [
    ./default.nix
  ];
  services.postgresql = {
    dataDir = "/persistent/${config.services.postgresql.package.psqlSchema}";
    enable = true;
    enableJIT = system != "riscv64-linux";
    enableTCPIP = true;
    extraPlugins = ps: with ps; [ rum ];
    package =
      if config.services.postgresql.enableJIT then pkgs.postgresql_17_jit else pkgs.postgresql_17;
  };
  services.postgresqlBackup = {
    compression = "zstd";
    compressionLevel = 19;
    enable = true;
    location = "/persistent/pgbackup";
  };
  system.stateVersion = "24.11";
}
