{config, ...}: {
  imports = [
    ../../modules/matrix/mautrix-telegram.nix
  ];
  services.mautrix-telegram-2 = {
    enable = true;
    environmentFile = config.sops.secrets."services/mautrix/telegram".path;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        http_retry_count = 1000;
        async_media = true;
      };
      appservice = {
        address = "http://localhost:29317";
        hostname = "0.0.0.0";
        port = 29317;
        max_body_size = 10;
        database = "postgres:///mautrix_telegram?sslmode=disable&host=/run/postgresql";
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
      };
      bridge = {
        displayname_template = "{displayname}";
        max_initial_member_sync = -1;
        sync_channel_members = true;
        startup_sync = true;
        sync_create_limit = 0;
        sync_deferred_create_all = true;
        public_portals = true;
        sync_with_custom_puppets = true;
        sync_direct_chat_list = true;
        invite_link_resolve = true;
        encryption = {
          allow = true;
          appservice = true;
          require = false;
          allow_key_sharing = true;
        };

        private_chat_portal_meta = "aways";
        delivery_receipts = true;
        pinned_tag = "m.favourite";
        archive_tag = "m.lowpriority";

        backfill = {
          enable = false;
          normal_groups = false;
          unread_hours_threshold = -1;
        };
        permissions = {
          "*" = "relaybot";
          "@lotte:chir.rs" = "admin";
        };
      };
      telegram = {
        api_id = "$API_ID";
        api_hash = "$API_HASH";
        bot_token = "$BOT_TOKEN";
        connection.retries = -1;
      };
    };
  };
  sops.secrets."services/mautrix/telegram".owner = "mautrix-telegram";
  services.postgresql.ensureDatabases = [
    "mautrix_telegram"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "mautrix-telegram";
      ensurePermissions = {
        "DATABASE mautrix_telegram" = "ALL PRIVILEGES";
      };
    }
  ];
}
