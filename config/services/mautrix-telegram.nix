{ lib, config, pkgs, ... }: {
  services.mautrix-telegram = {
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
        double_puppet_server_map = {
          chir.rs = "https://matrix.chir.rs";
        };
        double_puppet_allow_discovery = true;
        invite_link_resolve = true;
        animated_sticker.target = "webm";
        encryption = {
          allow = true;
          default = true;
          keysharing.allow = true;
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
  services.postgresql.ensureUsers = [{
    name = "mautrix-telegram";
    ensurePermissions = {
      "DATABASE mautrix_telegram" = "ALL PRIVILEGES";
    };
  }];
  users.users.mautrix-telegram = {
    description = "Mautrix telegram bridge";
    home = "/var/lib/mautrix-telegram";
    useDefaultShell = true;
    group = "dendrite";
    isSystemUser = true;
  };
  systemd.services.mautrix-telegram.serviceConfig = {
    User = "mautrix-telegram";
    Group = "dendrite";
    DynamicUser = lib.mkForce false;
  };
}
