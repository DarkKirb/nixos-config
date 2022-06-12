{
  lib,
  config,
  pkgs,
  ...
}: let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
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

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
  };
}
