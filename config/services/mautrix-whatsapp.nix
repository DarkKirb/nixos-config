{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/matrix/mautrix-whatsapp.nix
  ];

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = config.sops.secrets."services/mautrix/shared_secret".path;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        async_media = true;
      };
      appservice = {
        max_body_size = 10;
      };
      metrics = {
        enabled = true;
        listen = "[::]:29319";
      };
      database = {
        type = "postgres";
        uri = "postgres:///mautrix_whatsapp?sslmode=disable&host=/run/postgresql";
      };
      bridge = {
        relay.enabled = true;
        permissions = {
          "*" = "relay";
          "@miifox:chir.rs" = "user";
          "@lotte:chir.rs" = "admin";
        };
      };
      matrix = {
        delivery_receipts = true;
      };

      backfill = {
        enabled = true;
      };
      encryption = {
        allow = true;
        default = false;
        appservice = true;
        allow_key_sharing = true;
      };
      double_puppet = {
        secrets = {
          "chir.rs" = "as_token:$SHARED_AS_TOKEN";
        };
      };
    };
  };
  sops.secrets."services/mautrix/shared_secret" = {};
  services.postgresql.ensureDatabases = [
    "mautrix_whatsapp"
  ];
}
