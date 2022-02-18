{ ... }: {
  imports = [
    ./postgres.nix
  ];
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@chir.rs";
    useSubstitutes = true;
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
  nix.settings.allowed-uris = [ "https://github.com/" "https://git.chir.rs/" ];
}
