{
  pkgs,
  config,
  ...
}: {
  systemd.services.sliding-sync = {
    description = "Sliding sync proxy for matrix";
    after = ["network.target" "matrix-synapse.service"];
    wantedBy = ["multi-user.target"];
    environment = {
      SYNCV3_SERVER = "https://matrix.chir.rs";
      SYNCV3_DB = "postgresql:///sliding_sync?sslmode=disable&host=/run/postgresql";
      SYNCV3_BINDADDR = "127.0.0.1:45587";
      SYNCV3_PROM = "0.0.0.0:50372";
      SYNCV3_OTLP_URL = "http://localhost:4317";
      SYNCV3_SENTRY_DSN = "https://18e36e6f16b5490c83364101717cddba@o253952.ingest.sentry.io/6449283";
    };
    serviceConfig = {
      Type = "simple";
      User = "sliding-sync";
      Group = "sliding-sync";
      Restart = "always";
      EnvironmentFile = config.sops.secrets."services/mautrix/sliding-sync".path;
      ExecStart = "${pkgs.sliding-sync}/bin/syncv3";
    };
  };
  sops.secrets."services/mautrix/sliding-sync" = {};
  users.users.sliding-sync = {
    description = "Matrix sliding sync proxy";
    isSystemUser = true;
    group = "sliding-sync";
  };
  users.groups.sliding-sync = {};
  services.postgresql.ensureDatabases = ["sliding_sync"];

  services.caddy.virtualHosts."sliding-sync.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:45587
    '';
  };
}
