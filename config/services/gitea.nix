{ config, ... }: {
  services.gitea = {
    enable = true;
    appName = "Lotte's Git";
    cookieSecure = true;
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
        MINIO_ENDPOINT = "minio.int.chir.rs:443";
        # minio credentials are exported in the environment
        MINIO_BUCKET = "gitea";
        MINIO_USE_SSL = "true";
      };
    };
  };

  services.nginx.virtualHosts."git.chir.rs" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://${config.services.gitea.httpAddress}:${toString config.services.gitea.httpPort}/";
      proxyWebsockets = true;
    };
  };

  services.postgresql.ensureDatabases = [ "gitea" ];
  services.postgresql.ensureUsers = [{
    name = "gitea";
    ensurePermissions = { "DATABASE gitea" = "ALL PRIVILEGES"; };
  }];

  systemd.services.gitea.serviceConfig.EnvironmentFile = "/run/secrets/services/gitea";
}
