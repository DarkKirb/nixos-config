{ config, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
in
{
  services.minio = {
    enable = true;
    rootCredentialsFile = "/run/secrets/security/minio/credentials_file";
  };
  services.prometheus.exporters.minio = {
    # TODO: doesn't work
    enable = true;
  };
  services.nginx.virtualHosts."minio.int.chir.rs" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000";
      proxyWebsockets = true;
    };
    locations."/web" = {
      proxyPass = "http://127.0.0.1:9001";
      proxyWebsockets = true;
    };
  };
}
