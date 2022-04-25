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
}
