{
  config,
  pkgs,
  lib,
  ...
}: let
  promtail_config = {
    server = {
      http_listen_port = 28183;
      grpc_listen_port = 0;
    };
    positions = {
      filename = "/tmp/positions.yaml";
    };
    client = {
      url = "http://nixos-8gb-fsn1-1.int.chir.rs:3100/loki/api/v1/push";
      external_labels.host = config.networking.hostName;
    };
    scrape_configs = [
      {
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels.job = "systemd-journal";
        };
        relabel_configs = [
          {
            source_labels = ["__journal__systemd_unit"];
            target_label = "unit";
          }
        ];
      }
    ];
  };
  promtail_yml = pkgs.writeText "promtail.yml" (lib.generators.toYAML {} promtail_config);
in {
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${promtail_yml}
      '';
    };
  };
}
