{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9001;
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
    ];
  };
}
