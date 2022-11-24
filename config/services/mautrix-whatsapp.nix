{pkgs, ...}: {
  imports = [
    ../../modules/matrix/mautrix-whatsapp.nix
  ];

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.int.chir.rs";
        domain = "chir.rs";
        async_media = true;
      };
      appservice = {
        database = {
          type = "postgres";
          uri = "postgres:///mautrix_whatsapp?sslmode=disable&host=/run/postgresql";
        };
      };
      metrics = {
        enabled = true;
        listen = "[::]:29319";
      };
      bridge = {
        displayname_template = "{{if .PushName}}{{.PushName}}{{else if .BusinessName}}{{.BusinessName}}{{else}}{{.JID}}{{end}}";
        personal_filtering_spaces = true;
        delivery_receipts = true;
        hystory_sync = {
          backfill = true;
          request_full_sync = true;
        };
        send_presence_on_typing = true;
        double_puppet_server_map = {};
        login_shared_secret_map = {};
        private_chat_portal_meta = true;
        mute_bridging = true;
        pinned_tag = "m.favourite";
        archive_tag = "m.lowpriority";
        allow_user_invite = true;
        disappearing_messages_in_groups = true;
        url_previews = true;
        encryption = {
          allow = true;
          default = true;
          require = true;
          allow_key_sharing = true;
        };
        permissions = {
          "@lotte:chir.rs" = "admin";
        };
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
