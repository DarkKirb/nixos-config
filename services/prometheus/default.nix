{ config, ... }:
{
  services.prometheus = {
    port = 26678;
    enable = true;

    retentionTime = "90d";

    checkConfig = false;

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
        job_name = "forgejo";
        static_configs = [
          {
            targets = [
              "instance-20221213-1915.int.chir.rs:6379"
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
        job_name = "pgbouncer";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:29714"
              "nixos-8gb-fsn1-1.int.chir.rs:29714"
              "instance-20221213-1915.int.chir.rs:29714"
              "thinkrac.int.chir.rs:29714"
              "rainbow-resort.int.chir.rs:29714"
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
        job_name = "lotte-chir-rs";
        metrics_path = "/.api/metrics";
        static_configs = [
          {
            targets = [
              "nas.int.chir.rs:5621"
              "nixos-8gb-fsn1-1.int.chir.rs:5621"
              "instance-20221213-1915.int.chir.rs:5621"
              "rainbow-resort.int.chir.rs:5621"
            ];
          }
        ];
      }
      {
        job_name = "restic";
        static_configs = [
          {
            targets = [
              "localhost:44632"
            ];
          }
        ];
      }
    ];
  };
  sops.secrets."services/akkoma-key" = {
    sopsFile = ./secrets.yaml;
    owner = "prometheus";
  };
}
