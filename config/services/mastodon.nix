{
  nix-packages,
  system,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit ((import ../../utils/getInternalIP.nix config)) listenIPs;
  listenStatements =
    lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs)
    + ''
      add_header Alt-Svc 'h3=":443"';
    '';
  sopsConfig = {
    owner = "mastodon";
    restartUnits = [
      "mastodon-streaming.service"
      "mastodon-web.service"
      "mastodon-sidekiq.service"
    ];
  };
  inherit (nix-packages.packages.${system}) mastodon;
in {
  imports = [
    ./elasticsearch.nix
    ../../modules/mastodon.nix
    ./statsd-exporter.nix
  ];
  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
    package = mastodon;
    elasticsearch = {
      host = "127.0.0.1";
    };
    localDomain = "chir.rs";
    extraConfig = {
      WEB_DOMAIN = "mastodon.chir.rs";
      REDIS_NAMESPACE = "mastodon";
      SINGLE_USER_MODE = "true";
      REDIS_HOST = "127.0.0.1";
      REDIS_PORT = toString config.services.redis.servers.mastodon.port;
      S3_ENABLED = "true";
      S3_BUCKET = "mastodon-chir-rs";
      S3_REGION = "us-west-000";
      S3_PROTOCOL = "https";
      S3_HOSTNAME = "s3.us-west-000.backblazeb2.com";
      S3_ENDPOINT = "https://s3.us-west-000.backblazeb2.com/";
      S3_ALIAS_HOST = "mastodon-assets.chir.rs";
      S3_OPEN_TIMEOUT = "120";
      S3_READ_TIMEOUT = "120";
      S3_MULTIPART_THRESHOLD = "5242880";
      STATSD_ADDR = "127.0.0.1:9125";
      MAX_TOOT_CHARS = "58913";
    };
    redis.createLocally = false;
    otpSecretFile = config.sops.secrets."services/mastodon/otpSecret".path;
    secretKeyBaseFile = config.sops.secrets."services/mastodon/secretKeyBase".path;
    smtp = {
      authenticate = true;
      createLocally = false;
      fromAddress = "mastodon@chir.rs";
      host = "mail.chir.rs";
      passwordFile = config.sops.secrets."services/mastodon/smtpPassword".path;
      user = "mastodon@chir.rs";
    };
    vapidPrivateKeyFile = config.sops.secrets."services/mastodon/vapid/private".path;
    vapidPublicKeyFile = config.sops.secrets."services/mastodon/vapid/public".path;
    s3AccessKeyIdFile = config.sops.secrets."services/mastodon/s3/key_id".path;
    s3SecretAccessKeyFile = config.sops.secrets."services/mastodon/s3/secret_key".path;
  };
  sops.secrets."services/mastodon/otpSecret" = sopsConfig;
  sops.secrets."services/mastodon/secretKeyBase" = sopsConfig;
  sops.secrets."services/mastodon/smtpPassword" = sopsConfig;
  sops.secrets."services/mastodon/vapid/private" = sopsConfig;
  sops.secrets."services/mastodon/vapid/public" = sopsConfig;
  sops.secrets."services/mastodon/s3/key_id" = sopsConfig;
  sops.secrets."services/mastodon/s3/secret_key" = sopsConfig;

  services.caddy.virtualHosts."mastodon.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    extraConfig = ''
      import baseConfig
      root * ${config.services.mastodon.package}/public
      root /system/* /var/lib/mastodon/public-system

      handle /api/v1/streaming/* {
        reverse_proxy {
          to http://127.0.0.1:${toString config.services.mastodon.streamingPort}
          header_up X-Forwarded-Proto https
        }
      }

      handle {
        file_server
      }

      handle_errors {
        reverse_proxy {
          to http://127.0.0.1:${toString config.services.mastodon.webPort}
          header_up X-Forwarded-Proto https
        }
      }
    '';
  };
  services.redis.servers.mastodon = {
    enable = true;
    bind = "127.0.0.1";
    databases = 1;
    port = 6379;
  };
  users.users.mastodon.home = lib.mkForce (toString config.services.mastodon.package);
  services.elasticsearch.package = pkgs.elasticsearch7;
}
