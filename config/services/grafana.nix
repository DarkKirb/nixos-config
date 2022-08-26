{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit ((import ../../utils/getInternalIP.nix config)) listenIPs;
  listenStatements =
    lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs)
    + ''
      add_header Alt-Svc 'h3=":443"';
    '';
in {
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
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:${toString config.services.grafana.port}
    '';
  };
}
