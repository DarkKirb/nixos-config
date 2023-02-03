{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./prometheus.nix
  ];
  services.grafana = {
    enable = true;
    domain = "grafana.int.chir.rs";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.caddy.virtualHosts.${config.services.grafana.domain} = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:${toString config.services.grafana.port}
    '';
  };
}
