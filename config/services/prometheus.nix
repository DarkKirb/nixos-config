{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9002;
    scrapeConfigs = [
      {
        job_name = "node_exporter";
        static_configs = [{
          targets = [
            "${config.services.prometheus.exporters.node.listenAddress}:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
      {
        job_name = "bind_exporter";
        static_configs = [{
          targets = [
            "${config.services.prometheus.exporters.bind.listenAddress}:${toString config.services.prometheus.exporters.bind.port}"
          ];
        }];
      }
      {
        job_name = "postgres_exporter";
        static_configs = [{
          targets = [
            "${config.services.prometheus.exporters.postgres.listenAddress}:${toString config.services.prometheus.exporters.postgres.port}"
          ];
        }];
      }
      {
        job_name = "minio_exporter";
        static_configs = [{
          targets = [
            "${config.services.prometheus.exporters.minio.listenAddress}:${toString config.services.prometheus.exporters.minio.port}"
          ];
        }];
      }
      {
        job_name = "gitea_exporter";
        static_configs = [{
          targets = [
            "${config.services.gitea.httpAddress}:${toString config.services.gitea.httpPort}"
          ];
        }];
      }
    ];
  };
}
