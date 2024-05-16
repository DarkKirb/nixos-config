{
  pkgs,
  config,
  ...
}: {
  services.mautrix-signal = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        http_retry_count = 1000;
        async_media = true;
      };
      appservice = {
        max_body_size = 10;
        database = "postgres:///mautrix_signal?sslmode=disable&host=/run/postgresql";
      };
      metrics = {
        enabled = true;
        listen = "[::]:29329";
      };
      bridge = {
        displayname_template = "{displayname}";
        autocreate_contact_portal = true;
        public_portals = true;
        sync_with_custom_puppets = true;
        sync_direct_chat_list = true;
        encryption = {
          allow = true;
          default = false;
          appservice = false;
          require = false;
          allow_key_sharing = true;
        };
        private_chat_portal_meta = true;
        delivery_receipts = true;
        periodic_sync = 86400;
        permissions = {
          "*" = "relay";
          "@lotte:chir.rs" = "admin";
        };
        relay.enabled = true;
      };
    };
  };
  services.postgresql.ensureDatabases = [
    "mautrix_signal"
  ];
}
