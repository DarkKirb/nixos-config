{ config, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
in
{
  imports = [
    /run/secrets/services/minio.nix
  ];
  services.minio = {
    enable = true;
    dataDir = [
      "/var/lib/minio/disk0"
      "/var/lib/minio/disk1"
      "/var/lib/minio/disk2"
      "/var/lib/minio/disk3"
    ];
  };
  services.prometheus.exporters.minio = {
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
  };
  services.nginx.virtualHosts."minio-console.int.chir.rs" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9001";
      proxyWebsockets = true;
    };
  };
}
