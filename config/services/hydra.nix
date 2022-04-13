{ lib, config, pkgs, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
  listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
    add_header Alt-Svc 'h3=":443"';
  '';
  clean-cache = pkgs.callPackage ../../packages/clean-s3-cache.nix { };
in
{
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
    ./nix-serve.nix
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
      <github_authorization>
        darkkirb = #github_token#
      </github_authorization>
    '';
    giteaTokenFile = "/run/secrets/services/hydra/gitea_token";
    githubTokenFile = "/run/secrets/services/hydra/github_token";
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
  nix.settings.allowed-uris = [ "https://github.com/" "https://git.chir.rs/" "https://minio.int.chir.rs/" "https://git.neo-layout.org/" ];
  sops.secrets."services/hydra/gitea_token" = { };
  sops.secrets."services/hydra/github_token" = { };
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
  systemd.services.clean-s3-cache = {
    enable = true;
    description = "Clean up S3 cache";
    serviceConfig = {
      ExecStart = "${clean-cache}/bin/clean-s3-cache.py";
    };
  };
  systemd.timers.clean-s3-cache = {
    enable = true;
    description = "Clean up S3 cache";
    requires = [ "clean-s3-cache.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 604800;
    };
  };
  sops.secrets."services/hydra/aws_credentials" = {
    owner = "hydra-queue-runner";
    path = "/var/lib/hydra/queue-runner/.aws/credentials";
    restartUnits = [ "hydra-queue-runner.service" ];
  };
}
