{pkgs, ...}: {
  imports = [
    ../../modules/matrix/mautrix-whatsapp.nix
  ];

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        async_media = true;
      };
      appservice = {
        database = {
          type = "postgres";
          uri = "postgres:///mautrix_whatsapp?sslmode=disable&host=/run/postgresql";
        };
        async_transactions = true;
      };
      metrics = {
        enabled = true;
        listen = "[::]:29319";
      };
      bridge = {
        displayname_template = "{{if .PushName}}{{.PushName}}{{else if .BusinessName}}{{.BusinessName}}{{else}}{{.JID}}{{end}}";
        personal_filtering_spaces = true;
        delivery_receipts = true;
        message_error_notices = true;
        identity_change_notices = true;
        hystory_sync = {
          backfill = true;
          request_full_sync = true;
        };
        user_avatar_sync = true;
        sync_with_custom_puppets = true;
        sync_direct_chat_list = true;
        sync_manual_marked_unread = true;
        private_chat_portal_meta = "always";
        parallel_member_sync = true;
        pinned_tag = "m.favourite";
        archive_tag = "m.lowpriority";
        allow_user_invite = true;
        url_previews = true;
        extev_polls = true;
        cross_room_replies = true;
        encryption = {
          allow = true;
          appservice = true;
          require = false;
          allow_key_sharing = true;
        };
        permissions = {
          "*" = "relay";
          "@lotte:chir.rs" = "admin";
        };
        relay.enabled = true;
      };
    };
  };
  services.postgresql.ensureDatabases = [
    "mautrix_whatsapp"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "mautrix-whatsapp";
      ensurePermissions = {
        "DATABASE mautrix_whatsapp" = "ALL PRIVILEGES";
      };
    }
  ];
}
