{config, ...}: {
  imports = [
    ../../modules/gitea.nix
    (import ../../modules/gateway-st.nix {name = "gitea";})
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
    httpAddress = "127.0.0.1";
    lfs.enable = true;
    rootUrl = "https://git.chir.rs/";
    storageSecretFile = "/run/secrets/services/gitea";
    settings = rec {
      storage = {
        STORAGE_TYPE = "minio";
        MINIO_ENDPOINT = "localhost:7777";
        MINIO_ACCESS_KEY_ID = "gitea";
        MINIO_SECRET_ACCESS_KEY = "#storageSecret#";
        MINIO_BUCKET = "gitea";
        MINIO_USE_SSL = "false";
      };
      openid = {
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
      };
      cache = {
        ENABLED = config.services.redis.servers.gitea.enable;
        ADAPTER = "redis";
        HOST = "redis://${config.services.redis.servers.gitea.bind}:${toString config.services.redis.servers.gitea.port}/0";
      };
      session = {
        PROVIDER = "redis";
        PROVIDER_CONFIG = "redis://${config.services.redis.servers.gitea.bind}:${toString config.services.redis.servers.gitea.port}/1";
      };
      metrics = {
        ENABLED = true;
        ENABLED_ISSUE_BY_LABEL = true;
        ENABLED_ISSUE_BY_REPOSITORY = true;
      };
      queue = {
        TYPE = "redis";
        CONN_STRING = "redis://${config.services.redis.servers.gitea.bind}:${toString config.services.redis.servers.gitea.port}/2";
      };
      packages.ENABLED = true;
      federation.ENABLED = true;
      "repository.signing" = {
        SIGNING_KEY = "C9974EDF9932B558";
        SIGNING_NAME = "Gitea";
        SIGNING_EMAIL = "gitea@chir.rs";
        INITIAL_COMMIT = "always";
        WIKI = "always";
        CRUD_ACTIONS = "always";
        MERGES = "always";
      };
    };
  };

  services.nginx.virtualHosts."git.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://${config.services.gitea.httpAddress}:${toString config.services.gitea.httpPort}/";
      proxyWebsockets = true;
    };
  };

  services.postgresql.ensureDatabases = ["gitea"];
  services.postgresql.ensureUsers = [
    {
      name = "gitea";
      ensurePermissions = {"DATABASE gitea" = "ALL PRIVILEGES";};
    }
  ];

  services.redis.servers.gitea = {
    enable = true;
    bind = "127.0.0.1";
    databases = 3;
    port = 6379;
  };
  sops.secrets."services/gitea" = {owner = "gitea";};
}
