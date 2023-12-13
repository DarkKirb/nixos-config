{config, ...}: {
  services.prometheus = {
    port = 26678;
    enable = true;

    retentionTime = "90d";

    # ingest the published nodes
    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:31941"
              "nixos-8gb-fsn1-1.int.chir.rs:31941"
              "instance-20221213-1915.int.chir.rs:31941"
              "rainbow-resort.int.chir.rs:31941"
              "thinkrac.int.chir.rs:31941"
            ];
          }
        ];
      }
      {
        job_name = "dovecot";
        static_configs = [
          {
            targets = [
              "nixos-8gb-fsn1-1.int.chir.rs:35496"
            ];
          }
        ];
      }
      {
        job_name = "forgejo";
        static_configs = [
          {
            targets = [
              "nixos-8gb-fsn1-1.int.chir.rs:6379"
            ];
          }
        ];
      }
      {
        job_name = "hydra";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:8905"
            ];
          }
        ];
      }
      {
        job_name = "kubo";
        metrics_path = "/debug/metrics/prometheus";
        static_configs = [
          {
            targets = [
              "instance-20221213-1915.int.chir.rs:5001"
              "nas.int.chir.rs:5001"
              "rainbow-road.int.chir.rs:5001"
              "thinkrac.int.chir.rs:5001"
            ];
          }
        ];
      }
      {
        job_name = "matrix-media-repo";
        static_configs = [
          {
            targets = [
              "nixos-8gb-fsn1-1.int.chir.rs:20855"
            ];
          }
        ];
      }
      {
        job_name = "rspamd";
        static_configs = [
          {
            targets = [
              "nixos-8gb-fsn1-1.int.chir.rs:58636"
            ];
          }
        ];
      }
      {
        job_name = "matrix-synapse";
        metrics_path = "/_synapse/metrics";
        static_configs = [
          {
            targets = [
              "instance-20221213-1915.int.chir.rs:8008"
            ];
          }
        ];
      }
      {
        job_name = "opentelemetry-collector";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:63174"
              "nixos-8gb-fsn1-1.int.chir.rs:63174"
              "instance-20221213-1915.int.chir.rs:63174"
              "rainbow-resort.int.chir.rs:63174"
              "thinkrac.int.chir.rs:63174"
            ];
          }
        ];
      }
      {
        job_name = "postgresql";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:1589"
              "nixos-8gb-fsn1-1.int.chir.rs:1589"
              "instance-20221213-1915.int.chir.rs:1589"
              "thinkrac.int.chir.rs:1589"
              "rainbow-resort.int.chir.rs:1589"
            ];
          }
        ];
      }
      {
        job_name = "akkoma";
        metrics_path = "/api/v1/akkoma/metrics";
        authorization.credentials_file = config.sops.secrets."services/akkoma-key".path;
        scheme = "https";
        static_configs = [
          {
            targets = [
              "akko.chir.rs"
            ];
          }
        ];
      }
      {
        job_name = "matrix-sliding-sync";
        static_configs = [
          {
            targets = [
              "instance-20221213-1915.int.chir.rs:50372"
            ];
          }
        ];
      }
    ];
  };
  sops.secrets."services/akkoma-key".owner = "prometheus";
}
