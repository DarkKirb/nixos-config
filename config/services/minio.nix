{ pkgs, config, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
in
{
  services.minio = {
    enable = false;
    rootCredentialsFile = "/run/secrets/security/minio/credentials_file";
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
  sops.secrets."security/minio/credentials_file" = { };
  systemd.services.minio = {
    enable = true;
    description = "Minio Object Storage";
    after = [ "network.target" ];
    environment = {
      MINIO_BROWSER = "on";
      MINIO_REGION = "eu-west-1";
      MINIO_CACHE = "on";
      MINIO_CACHE_DRIVES = "/var/cache/minio";
      MINIO_CACHE_QUOTA = "80";
      MINIO_CACHE_WATERMARK_LOW = "70";
      MINIO_CACHE_WATERMARK_HIGH = "90";
    };
    serviceConfig = {
      EnvironmentFile = "/run/secrets/security/minio/credentials_file";
      ExecStart = "${pkgs.minio}/bin/minio gateway s3 --json --address :9000 --console-address :9001 --config-dir=/var/lib/minio/config  http://[fd00:e621:e621:2::2]:9000";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
