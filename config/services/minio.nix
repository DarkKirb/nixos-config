{ config, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
in
{
  services.minio = {
    enable = true;
    rootCredentialsFile = "/run/secrets/security/minio/credentials_file";
    dataDir = [
      "/var/lib/minio/disk0"
      "/var/lib/minio/disk1"
      "/var/lib/minio/disk2"
      "/var/lib/minio/disk3"
    ];
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
