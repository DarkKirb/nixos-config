{ config, pkgs, lib, ... }:
let promtail_config = {
  server = {
    http_listen_port = 28183;
    grpc_listen_port = 0;
  };
  positions = {
    filename = "/tmp/positions.yaml";
  };
  client = {
    url = "http://[fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49]:3100/loki/api/v1/push";
    external_labels.host = config.networking.hostName;
  };
  scrapeConfigs = [
    {
      job_name = "journal";
      journal = {
        max_age = "12h";
        labels.job = "systemd-journal";
      };
      relabel_configs = [
        {
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }
      ];
    }
  ];
};
in
{
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${lib.generators.toYAML promtail_config}
      '';
    };
  };
}
