{pkgs, ...}: {
  imports = [
    ../../modules/matrix/mautrix-discord.nix
  ];

  services.mautrix-discord = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
      };
      appservice = {
        database = {
          type = "postgres";
          uri = "postgres:///mautrix_discord?sslmode=disable&host=/run/postgresql";
        };
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
        backfill = {
          forward_limits = {
            initial.dm = 50;
            initial.channel = 50;

            missed.dm = -1;
            missed.channel = -1;
          };
        };
        encryption = {
          allow = true;
          appservice = true;
          allow_key_sharing = true;
        };
        permissions = {
          "*" = "relay";
          "@lotte:chir.rs" = "admin";
        };
      };
    };
  };
  services.postgresql.ensureDatabases = [
    "mautrix_discord"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "mautrix-discord";
      ensurePermissions = {
        "DATABASE mautrix_discord" = "ALL PRIVILEGES";
      };
    }
  ];
}
