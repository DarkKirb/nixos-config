{ ... }:
let
  homepage-old = import ../../packages/old-homepage.nix { };
in
{
  systemd.services.homepage-old = {
    enable = true;
    description = "darkkirb.de";
    script = "${homepage-old.homepage-old}/homepage";
    serviceConfig = {
      WorkingDirectory = homepage-old.homepage-old;
      EnvironmentFile = "/run/secrets/services/old-homepage";
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.nginx.virtualHosts."darkkirb.de" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/darkkirb.de/cert.pem";
    sslCertificateKey = "/var/lib/acme/darkkirb.de/key.pem";
    serverAliases = [ "www.darkkirb.de" ];
    locations."/" = {
      proxyPass = "http://localhost:3002/";
    };
    locations."/.well-known/matrix" = {
      proxyPass = "http://localhost:3002/.well-known/matrix";
      extraConfig = "add_header Access-Control-Allow-Origin '*';";
    };
  };
  services.nginx.virtualHosts."static.darkkirb.de" = {
    addSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/darkkirb.de/cert.pem";
    sslCertificateKey = "/var/lib/acme/darkkirb.de/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000/darkkirb.de/";
    };
  };
  sops.secrets."services/old-homepage" = { };
}
