{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/gitea.nix
  ];
  services.gitea = {
    package = pkgs.forgejo;
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
        MINIO_ENDPOINT = "ams1.vultrobjects.com";
        MINIO_ACCESS_KEY_ID = "X86D3HKJ3Y92IASK0XIG";
        MINIO_SECRET_ACCESS_KEY = "#storageSecret#";
        MINIO_BUCKET = "git-chir-rs";
        MINIO_USE_SSL = "true";
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
        SIGNING_KEY = "823566455E49DDC6AE5813048CA13817A54AAB38";
        SIGNING_NAME = "Gitea";
        SIGNING_EMAIL = "gitea@chir.rs";
        INITIAL_COMMIT = "always";
        WIKI = "always";
        CRUD_ACTIONS = "always";
        MERGES = "always";
      };
      git = {
        HOME_PATH = "/var/lib/gitea";
      };
    };
  };

  services.caddy.virtualHosts."git.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://${config.services.gitea.httpAddress}:${toString config.services.gitea.httpPort}
    '';
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
  services.prometheus.scrapeConfigs = [
    {
      job_name = "forgejo";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${toString config.config.services.gitea.httpPort}"
          ];
        }
      ];
    }
  ];
}
