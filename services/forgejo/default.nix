{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database = {
      createDatabase = false;
      host = "localhost";
      name = "gitea";
      passwordFile = config.sops.secrets."services/forgejo/database/password".path;
      port = 6432;
      type = "postgres";
      user = "gitea";
    };
    user = "gitea";
    group = "gitea";
    stateDir = "/var/lib/gitea";
    lfs.enable = true;
    secrets = {
      storage = {
        MINIO_ACCESS_KEY_ID = config.sops.secrets."services/forgejo/secrets/MINIO_ACCESS_KEY_ID".path;
        MINIO_SECRET_ACCESS_KEY =
          config.sops.secrets."services/forgejo/secrets/MINIO_SECRET_ACCESS_KEY".path;
      };
    };
    settings = {
      storage = {
        STORAGE_TYPE = "minio";
        MINIO_ENDPOINT = "ams1.vultrobjects.com";
        MINIO_BUCKET = "git-chir-rs";
        MINIO_USE_SSL = "true";
      };
      openid = {
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
      };
      server.DOMAIN = "git.chir.rs";
      server.ROOT_URL = "https://git.chir.rs/";
      session.COOKIE_SECURE = true;
      metrics = {
        ENABLED = true;
        ENABLED_ISSUE_BY_LABEL = true;
        ENABLED_ISSUE_BY_REPOSITORY = true;
      };
      packages.ENABLED = true;
      federation.ENABLED = true;
      git = {
        HOME_PATH = config.services.forgejo.stateDir;
      };
    };
  };
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "gitea" ];
  };
  services.pgbouncer.settings.databases = {
    gitea = "host=127.0.0.1 port=5432 auth_user=gitea dbname=gitea";
  };
  sops.secrets."services/forgejo/database/password" = {
    owner = "gitea";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/forgejo/secrets/MINIO_ACCESS_KEY_ID" = {
    owner = "gitea";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/forgejo/secrets/MINIO_SECRET_ACCESS_KEY" = {
    owner = "gitea";
    sopsFile = ./secrets.yaml;
  };
  users.users.${config.services.forgejo.user} = {
    description = "Forgejo Service";
    home = config.services.forgejo.stateDir;
    useDefaultShell = true;
    group = config.services.forgejo.group;
    isSystemUser = true;
  };
  users.groups.${config.services.forgejo.group} = { };
  services.caddy.virtualHosts."git.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig

      @badbots {
        header 'User-Agent' *Bytespider*
        header 'User-Agent' *meta-externalagent*
        header 'User-Agent' *claudebot*
        header 'User-Agent' *imagesift*
        header 'User-Agent' *amazon*
      }

      respond @badbots 403

      handle_path /robots.txt {
        root ${./static}
        try_files /robots.txt =404
        file_server
      }

      reverse_proxy http://${config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
    '';
  };

  services.openssh.settings.AcceptEnv = lib.mkForce "GIT_PROTOCOL WAYLAND_DISPLAY";
}
