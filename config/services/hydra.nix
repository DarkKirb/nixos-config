{ lib, config, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
  listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
    add_header Alt-Svc 'h3=":443"';
  '';
in
{
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
    #./nix-cache-upload.nix
  ];
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.int.chir.rs/";
    notificationSender = "hydra@chir.rs";
    useSubstitutes = true;
    extraConfig = ''
      <gitea_authorization>
        darkkirb = #gitea_token#
      </gitea_authorization>
      store_uri = s3://nix-cache?scheme=https&endpoint=cache.int.chir.rs&secret-key=/var/lib/hydra/queue-runner/cache-priv-key.pem&multipart-upload=true
    '';
    giteaTokenFile = "/run/secrets/services/hydra/gitea_token";
  };
  services.postgresql.ensureDatabases = [ "hydra" ];
  services.postgresql.ensureUsers = [
    {
      name = "hydra";
      ensurePermissions = {
        "DATABASE hydra" = "ALL PRIVILEGES";
      };
    }
  ];
  nix.settings.allowed-uris = [ "https://github.com/" "https://git.chir.rs/" "https://minio.int.chir.rs/" ];
  sops.secrets."services/hydra/gitea_token" = { };
  services.nginx.virtualHosts."hydra.int.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
  };
}
