{ config, ... }:
{
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 45871;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://nas.int.chir.rs:24545/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "${config.networking.hostName}";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__hostname" ];
              target_label = "host";
            }
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
            {
              source_labels = [ "__journal__systemd_user_unit" ];
              target_label = "user_unit";
            }
            {
              source_labels = [ "__journal__transport" ];
              target_label = "transport";
            }
            {
              source_labels = [ "__journal_priority_keyword" ];
              target_label = "severity";
            }
          ];
        }
      ];
    };
    # extraFlags
  };
}
