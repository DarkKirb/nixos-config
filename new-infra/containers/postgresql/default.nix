{pkgs, ...}: {
  containers.postgresql = rec {
    autoStart = true;
    privateNetwork = true;
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    ephemeral = true;
    bindMounts = {
      persist = {
        mountPoint = "/persist";
        hostPath = "/persist/postgresql";
        isReadOnly = false;
      };
      backup = {
        mountPoint = "/backup";
        hostPath = "/persist/backup/postgresql";
        isReadOnly = false;
      };
    };

    config = {
      config,
      pkgs,
      ...
    }: {
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
      system.stateVersion = "24.05";
      systemd.tmpfiles.rules = [
        "d /persist - postgres postgres - -"
        "d /backup - postgres postgres - -"
      ];
      services.prometheus.exporters.postgres.enable = true;
      networking.firewall.extraCommands = ''
        ip6tables -A nixos-fw -p tcp -s _gateway -m tcp --dport ${toString config.services.prometheus.exporters.postgres.port} -m comment --comment postgres-exporter -j nixos-fw-accept
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d /persist/postgresql - - - - -"
    "d /persist/backup/postgresql - - - - -"
  ];
}
