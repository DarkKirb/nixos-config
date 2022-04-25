{ config, ... }:
let
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
  ];
  services.mastodon = {
    enable = true;
    elasticsearch = {
      host = "127.0.0.1";
    };
    localDomain = "chir.rs";
    extraConfig = {
      WEB_DOMAIN = "mastodon.darkkirb.de";
      REDIS_NAMESPACE = "mastodon";
      SINGLE_USER_MODE = true;
    };
    otpSecretFile = config.secrets."services/mastodon/otpSecret".path;
    secretKeyBaseFile = config.secrets."services/mastodon/secretKeyBase".path;
    smtp = {
      authenticate = true;
      createLocally = false;
      fromAddress = "mastodon@chir.rs";
      host = "mail.chir.rs";
      passwordFile = config.secrets."services/mastodon/smtpPassword".path;
      user = "mastodon@chir.rs";
    };
    vapidPrivateKeyFile = config.secrets."services/mastodon/vapid/private".path;
    vapidPublicKeyFile = config.secrets."services/mastodon/vapid/public".path;
  };
  sops.secrets."services/mastodon/otpSecret" = sopsConfig;
  sops.secrets."services/mastodon/secretKeyBase" = sopsConfig;
  sops.secrets."services/mastodon/smtpPassword" = sopsConfig;
  sops.secrets."services/mastodon/vapid/private" = sopsConfig;
  sops.secrets."services/mastodon/vapid/public" = sopsConfig;

  services.nginx.virtualHosts."mastodon.chir.rs" = {
    root = "${config.services.mastodon.package}/public/";
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/system/".alias = "/var/lib/mastodon/public-system/";

    locations."/" = {
      tryFiles = "$uri @proxy";
    };
    locations."@proxy" = {
      proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(config.services.mastodon.webPort)}");
      proxyWebsockets = true;
    };
    locations."/api/v1/streaming/" = {
      proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-streaming/streaming.socket" else "http://127.0.0.1:${toString(config.services.mastodon.streamingPort)}/");
      proxyWebsockets = true;
    };
  };
}
