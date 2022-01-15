{ config, pkgs, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
in
{
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
    forceSSL = true;
    http2 = true;
    # http3 = true;
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
