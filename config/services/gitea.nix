{ ... }: {
  services.gitea = {
    enable = true;
    appName = "Lotte's Git";
    cookiesSecure = true;
    database = {
      host = "localhost";
      name = "gitea";
      user = "gitea";
    };
    domain = "git.chir.rs";
    dump.enable = true;
    httpAddress = "127.0.0.1";
    lfs.enable = true;
    rootUrl = "https://git.chir.rs/";
    settings = {
      lfs = {
        STORAGE_TYPE = "";
      };
      storage = {
        STORAGE_TYPE = "minio";
        MINIO_ENDPOINT = "https://minio.int.chir.rs/";
        # minio credentials are exported in the environment
        MINIO_BUCKET = "gitea";
        MINIO_USE_SSL = "true";
      };
    };
  };

  services.postgresql.ensureDatabases = [ "gitea" ];
  services.postgresql.ensureUsers = [{
    name = "gitea";
    ensurePermissions = { "DATABASE gitea" = "ALL PRIVILEGES"; };
  }];

  systemd.services.gitea.serviceConfig.EnvironmentFile = "/run/secrets/services/gitea";
}
