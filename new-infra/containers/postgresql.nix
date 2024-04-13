{pkgs, ...}: {
  containers.postgresql = {
    autoStart = true;
    privateNetwork = true;
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    ephemeral = true;
    bindMounts = {
      persist = {
        mountPoint = "/persist";
        hostPath = "/persist/postgresql";
      };
      backup = {
        mountPoint = "/backup";
        hostPath = "/persist/backup/postgresql";
      };
    };

    config = {pkgs, ...}: {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_16;
        dataDir = "/persist/16";
      };
      services.postgresqlBackup = {
        enable = true;
        pgdumpOptions = "-C";
        location = "/backup";
        compression = "zstd";
        compressionLevel = 19;
      };
      networking.firewall = {
        enable = true;
      };
    };
  };
}
