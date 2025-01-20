{
  config,
  pkgs,
  ...
}:
{
  services.peertube = {
    enable = true;
    localDomain = "peertube.chir.rs";
    listenHttp = 5370;
    listenWeb = 443;
    enableWebHttps = true;
    serviceEnvironmentFile = config.sops.secrets."services/peertube/env".path;
    secrets.secretsFile = config.sops.secrets."services/peertube/secret".path;
    settings = {
      object_storage = {
        upload_acl.public = "private";
        enabled = true;
        endpoint = "ams1.vultrobjects.com";
        videos = {
          bucket_name = "mastodon-assets-chir-rs";
          prefix = "peertube/videos/";
          base_url = "https://mastodon-assets.chir.rs";
        };
        streaming_playlists = {
          bucket_name = "mastodon-assets-chir-rs";
          prefix = "peertube/streaming-playlists/";
          base_url = "https://mastodon-assets.chir.rs";
        };
      };
    };
    database = {
      host = "localhost";
      port = 6432;
      passwordFile = config.sops.secrets."services/peertube/dbPassword".path;
    };
    redis.createLocally = true;
  };
  services.caddy.virtualHosts."peertube.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      reverse_proxy {
        to http://127.0.0.1:5370
      }
    '';
  };
  sops.secrets."services/peertube/env" = {
    sopsFile = ./secrets.yaml;
    owner = "peertube";
  };
  sops.secrets."services/peertube/secret" = {
    sopsFile = ./secrets.yaml;
    owner = "peertube";
  };
  sops.secrets."services/peertube/dbPassword" = {
    sopsFile = ./secrets.yaml;
    owner = "peertube";
  };
  services.postgresql = {
    ensureDatabases = [ "peertube" ];
    ensureUsers = [
      {
        name = "peertube";
        ensureDBOwnership = true;
      }
    ];
  };
  services.pgbouncer.settings.databases = {
    peertube = "host=127.0.0.1 port=5432 auth_user=peertube dbname=peertube";
  };
}
