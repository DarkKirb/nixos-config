{ ... }: {
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
    #./nix-cache-upload.nix
  ];
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
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
}
