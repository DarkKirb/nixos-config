{ config, ... }: {
  imports = [
    /run/secrets/services/gitea.nix
  ];
  services.gitea = {
    enable = true;
    appName = "Lotte's Git";
    cookieSecure = true;
    database = {
      host = "localhost";
      name = "gitea";
      user = "gitea";
      type = "postgres";
    };
    domain = "git.chir.rs";
    dump.enable = true;
    httpAddress = "127.0.0.1";
    lfs.enable = true;
    rootUrl = "https://git.chir.rs/";
    settings = rec {
      lfs = {
        STORAGE_TYPE = "default";
      };
      storage = {
        STORAGE_TYPE = "minio";
        MINIO_ENDPOINT = "minio.int.chir.rs:443";
        MINIO_ACCESS_KEY_ID = "gitea";
        MINIO_BUCKET = "gitea";
        MINIO_USE_SSL = "true";
      };
      openid = {
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
      };
      cache = {
        ENABLED = config.services.redis.servers.gitea.enable;
        ADAPTER = "redis";
        HOST = "redis://${config.services.redis.servers.gitea.host}:${config.services.redis.servers.gitea.port}/0";
      };
      "storage.default" = storage;
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

  services.redis.servers.gitea = {
    enable = true;
    bind = "127.0.0.1";
    databases = 1;
  };
}
