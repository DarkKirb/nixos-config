{
  config,
  pkgs,
  lib,
  ...
}: {
  services.peertube = {
    enable = true;
    localDomain = "peertube.chir.rs";
    listenHttp = 5370;
    listenWeb = 443;
    enableWebHttps = true;
    serviceEnvironmentFile = config.sops.secrets."services/peertube".path;
    settings = {
      object_storage = {
        enabled = true;
        endpoint = "s3.us-west-000.backblazeb2.com";
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
  systemd.services.peertube.path = with pkgs; lib.mkForce [bashInteractive ffmpeg_5 nodejs-16_x openssl yarn python3 coreutils systemd];
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
