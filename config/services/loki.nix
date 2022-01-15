{ pkgs, ... }: {
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtrail.yaml}
      '';
    };
  };
}
