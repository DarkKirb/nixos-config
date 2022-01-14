{ config, pkgs, ... }:
let
  removeCIDR = cidr: builtins.elemAt (builtins.split "/" cidr) 0;
  filterIPs = cidrs: builtins.map (f: "[${removeCIDR f}]") cidrs;
  listenIPs = filterIPs config.networking.wireguard.interfaces."wg0".ips;
in
{
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
