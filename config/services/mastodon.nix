{ config, lib, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
  listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
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
in
{
  imports = [
    ./elasticsearch.nix
    ../../modules/mastodon.nix
  ];
  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
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
      S3_ALIAS_HOST = "mastodon-assets.chir.rs";
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
    s3SecretKeyFile = config.sops.secrets."services/mastodon/s3/secret_key".path;
  };
  sops.secrets."services/mastodon/otpSecret" = sopsConfig;
  sops.secrets."services/mastodon/secretKeyBase" = sopsConfig;
  sops.secrets."services/mastodon/smtpPassword" = sopsConfig;
  sops.secrets."services/mastodon/vapid/private" = sopsConfig;
  sops.secrets."services/mastodon/vapid/public" = sopsConfig;
  sops.secrets."services/mastodon/s3/key_id" = sopsConfig;
  sops.secrets."services/mastodon/s3/secret_key" = sopsConfig;

  services.nginx.virtualHosts =
    let mastodon = {
      listenAddresses = listenIPs;
      root = "${config.services.mastodon.package}/public/";
      locations."/system/".alias = "/var/lib/mastodon/public-system/";

      locations."/" = {
        tryFiles = "$uri @proxy";
      };
      locations."@proxy" = {
        proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(config.services.mastodon.webPort)}");
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
      locations."/api/v1/streaming/" = {
        proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-streaming/streaming.socket" else "http://127.0.0.1:${toString(config.services.mastodon.streamingPort)}/");
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
    };
    in
    {
      "mastodon.chir.rs" = mastodon // {
        sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
      };
      "mastodon.int.chir.rs" = mastodon // {
        sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
      };
    };
  services.redis.servers.mastodon = {
    enable = true;
    bind = "127.0.0.1";
    databases = 1;
    port = 6379;
  };
  users.users.mastodon.home = lib.mkForce (toString config.services.mastodon.package);
}
