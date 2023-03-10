{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/matrix/mautrix-telegram.nix
  ];
  services.mautrix-telegram-2 = {
    enable = true;
    environmentFile = config.sops.secrets."services/mautrix/telegram".path;
    settings = {
      homeserver = {
        address = "https://matrix.int.chir.rs";
        domain = "chir.rs";
        http_retry_count = 1000;
      };
      appservice = {
        address = "http://localhost:29317";
        hostname = "127.0.0.1";
        port = 29317;
        max_body_size = 10;
        database = "postgres:///mautrix_telegram?sslmode=disable&host=/run/postgresql";
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
      };
      bridge = {
        displayname_template = "{displayname}";
        allow_avatar_remove = true;
        max_initial_member_sync = -1;
        sync_create_limit = 0;
        sync_direct_chats = true;
        sync_direct_chat_list = true;
        double_puppet_server_map = {};
        login_shared_secret_map = {};
        double_puppet_allow_discovery = true;
        invite_link_resolve = true;
        animated_sticker.target = "webm";
        sync_channel_members = true;
        startup_sync = true;
        sync_deferred_create_all = true;
        sync_with_custom_puppets = true;
        encryption = {
          allow = true;
          default = true;
          require = true;
          allow_key_sharing = true;
        };
        private_chat_portal_meta = true;
        mute_bridging = true;
        backfill = {
          msc2716 = true;
          normal_groups = true;
          unread_hours_threshold = -1;
          incremental.max_batches.supergroup = -1;
        };
        delivery_receipts = true;
        delivery_error_reports = true;
        pinned_tag = "m.favourite";
        archive_tag = "m.lowpriority";
        permissions = {
          "@lotte:chir.rs" = "admin";
        };
      };
      telegram = {
        api_id = "$API_ID";
        api_hash = "$API_HASH";
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
