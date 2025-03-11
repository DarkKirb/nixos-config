{
  config,
  ...
}:
{
  services.mautrix-discord = {
    enable = true;
    environmentFile = config.sops.secrets."services/mautrix/shared_secret".path;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        async_media = true;
      };
      appservice = {
        database = {
          type = "postgres";
          uri = "postgres:///mautrix_discord?sslmode=disable&host=/run/postgresql";
        };
        ephemeral_events = true;
        async_transactions = true;
      };
      metrics = {
        enabled = true;
        listen = "[::]:29321";
      };
      bridge = {
        channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}} ({{.GuildName}} — {{.ParentName}}){{else}}#{{.Name}} ({{.GuildName}} — {{.ParentName}}){{end}}";
        private_chat_portal_meta = "always";
        startup_private_channel_create_limit = 25;
        delivery_receipts = true;
        sync_direct_chat_list = true;
        delete_portal_on_channel_delete = true;
        prefix_webhook_messages = true;
        cache_media = "always";
        animated_sticker.target = "disable";
        backfill = {
          forward_limits = {
            initial.dm = 50;
            initial.channel = 50;
            initial.thread = 50;

            missed.dm = -1;
            missed.channel = -1;
            missed.thread = -1;
          };
        };
        encryption = {
          allow = true;
          default = false;
          appservice = true;
          require = false;
          plaintext_mentions = true;
          allow_key_sharing = true;
        };
        permissions = {
          "*" = "relay";
          "@miifox:chir.rs" = "user";
          "@lotte:chir.rs" = "admin";
        };
        login_shared_secret_map = {
          "chir.rs" = "as_token:$SHARED_AS_TOKEN";
        };
      };
    };
  };
  sops.secrets."services/mautrix/shared_secret" = {
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/mautrix/discord.yaml" = {
    owner = "mautrix-discord";
    sopsFile = ./secrets.yaml;
  };
  services.postgresql.ensureDatabases = [
    "mautrix_discord"
  ];
}
