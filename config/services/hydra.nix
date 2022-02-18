{ ... }: {
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
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
