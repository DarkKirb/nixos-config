{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9002;
    globalConfig = {
      scrape_interval = "10s";
      scrape_timeout = "2s";
    };
    scrapeConfigs = [
      {
        job_name = "node_exporter";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:${toString config.services.prometheus.exporters.node.port}"
            "nutty-noon.int.chir.rs:${toString config.services.prometheus.exporters.node.port}"
            "nas.int.chir.rs:${toString config.services.prometheus.exporters.node.port}"
            "thinkrac.int.chir.rs:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
      {
        job_name = "bind_exporter";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:${toString config.services.prometheus.exporters.bind.port}"
          ];
        }];
      }
      {
        job_name = "postgres_exporter";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:${toString config.services.prometheus.exporters.postgres.port}"
            "nas.int.chir.rs:${toString config.services.prometheus.exporters.postgres.port}"
          ];
        }];
      }
      {
        job_name = "gitea_exporter";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:${toString config.services.gitea.httpPort}"
          ];
        }];
      }
      {
        job_name = "dovecot_exporter";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:${toString config.services.prometheus.exporters.dovecot.port}"
          ];
        }];
      }
      {
        job_name = "hydra_exporter";
        static_configs = [{
          targets = [
            "nas.int.chir.rs:9199"
          ];
        }];
      }
      {
        job_name = "statsd_exporter";
        static_configs = [{
          targets = [
            "nas.int.chir.rs:9102"
          ];
        }];
      }
      {
        job_name = "matrix_media_repo";
        static_configs = [{
          targets = [
            "nixos-8gb-fsn1-1.int.chir.rs:9000"
          ];
        }];
      }
      {
        job_name = "rspamd_exporter";
        static_configs = [{
          targets = [
            "nas.int.chir.rs:7980"
          ];
        }];
      }
      {
        job_name = "synapse";
        metrics_path = "/_synapse/metrics";
        static_configs = [{
          targets = [
            "matrix.int.chir.rs:80"
          ];
        }];
      }
    ];
    checkConfig = false;
  };
}
