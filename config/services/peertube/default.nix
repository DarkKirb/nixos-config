{ config, ... }: {
  services.peertube = {
    enable = true;
    localDomain = "peertube.chir.rs";
    listenHttp = 5370;
    listenWeb = 5370;
    serviceEnvironmentFile = config.sops.secrets."services/peertube".path;
    settings = {
      object_storage = {
        enabled = true;
        endpoint = "s3.us-west-001.backblazeb2.com";
        videos = {
          bucket_name = "mastodon-chir-rs";
          prefix = "peertube/videos/";
          base_url = "https://mastodon-assets.chir.rs/";
        };
        streaming_playlists = {
          bucket_name = "mastodon-chir-rs";
          prefix = "peertube/streaming-playlists/";
          base_url = "https://mastodon-assets.chir.rs/";
        };
      };
    };
    database.createLocally = true;
    redis.createLocally = true;
  };
  services.caddy.virtualHosts."peertube.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      reverse_proxy {
        to http://127.0.0.1:5370
      }
    '';
  };
  sops.secrets."services/peertube".owner = "peertube";
}
