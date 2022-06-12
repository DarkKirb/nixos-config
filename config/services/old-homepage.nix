{ nix-packages, system, ... }:
let
  homepage-old = nix-packages.packages.${system}.homepage-old;
in
{
  systemd.services.homepage-old = {
    enable = true;
    description = "darkkirb.de";
    script = "${homepage-old}/homepage";
    serviceConfig = {
      WorkingDirectory = homepage-old;
      EnvironmentFile = "/run/secrets/services/old-homepage";
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.nginx.virtualHosts."darkkirb.de" = {
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
    forceSSL = false;
    addSSL = true;
    sslCertificate = "/var/lib/acme/darkkirb.de/cert.pem";
    sslCertificateKey = "/var/lib/acme/darkkirb.de/key.pem";
    locations."/" = {
      proxyPass = "https://f000.backblazeb2.com/file/darkkirb-de/";
    };
  };
  sops.secrets."services/old-homepage" = { };
}
