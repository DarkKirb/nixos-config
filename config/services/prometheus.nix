{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9002;
    scrapeConfigs = [
      {
        job_name = "node_exporter";
        static_configs = [{
          targets = [
            "[fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49]:${toString config.services.prometheus.exporters.node.port}"
            "[fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437]:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
      {
        job_name = "bind_exporter";
        static_configs = [{
          targets = [
            "[fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49]:${toString config.services.prometheus.exporters.bind.port}"
          ];
        }];
      }
      {
        job_name = "postgres_exporter";
        static_configs = [{
          targets = [
            "[fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49]:${toString config.services.prometheus.exporters.postgres.port}"
          ];
        }];
      }
      {
        job_name = "gitea_exporter";
        static_configs = [{
          targets = [
            "[fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49]:${toString config.services.gitea.httpPort}"
          ];
        }];
      }
      {
        job_name = "minio_exporter";
        bearer_token_file = "/run/secrets/services/minio_scrape";
        metrics_path = "/minio/v0/metrics/cluster";
        scheme = "https";
        static_configs = [
          {
            targets = [
              "minio.int.chir.rs"
            ];
          }
        ];
      }
    ];
  };
  sops.secrets."services/minio_scrape" = {
    owner = "prometheus";
  };
}
