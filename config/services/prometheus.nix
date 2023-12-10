{config, ...}: {
  services.prometheus = {
    port = 26678;
    enable = true;

    exporters = {
      node = {
        port = 31941;
        enabledCollectors = [
          "buddyinfo"
          "cgroups"
          "systemd"
          "ethtool"
        ];
        enable = true;
      };
    };

    # ingest the published nodes
    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];
  };
}
