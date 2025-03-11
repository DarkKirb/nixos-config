{
  config,
  ...
}:
{
  imports = [
    ../../modules/matrix/mautrix-slack.nix
  ];

  services.mautrix-slack = {
    enable = true;
    environmentFile = config.sops.secrets."services/mautrix/shared_secret".path;
    settings = {
      bridge = {
        permissions = {
          "*" = "relay";
          "@miifox:chir.rs" = "user";
          "@lotte:chir.rs" = "admin";
        };
      };
      database = {
        type = "postgres";
        uri = "postgres:///mautrix_slack?sslmode=disable&host=/run/postgresql";
      };
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        async_media = true;
      };
      appservice = {
        ephemeral_events = true;
        async_transactions = true;
      };
      backfill = {
        enabled = true;
        queue.enabled = true;
      };
      encryption = {
        allow = true;
        default = false;
        appservice = false;
      };
    };
  };
  sops.secrets."services/mautrix/shared_secret".sopsFile = ./secrets.yaml;
  services.postgresql.ensureDatabases = [
    "mautrix_slack"
  ];
  sops.secrets."services/mautrix/slack.yaml" = {
    sopsFile = ./secrets.yaml;
    owner = "mautrix-slack";
  };
}
