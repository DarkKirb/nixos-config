{ lib, config, pkgs, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
  listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
    add_header Alt-Svc 'h3=":443"';
  '';
in
{
  imports = [
    (import ../../modules/gateway-st.nix {
      name = "nix-cache";
      port = 7778;
    })
  ];
  services.nginx.virtualHosts."cache.int.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://localhost:7778/";
      proxyWebsockets = true;
    };
  };
}
