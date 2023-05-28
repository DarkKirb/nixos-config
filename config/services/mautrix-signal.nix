{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/matrix/mautrix-signal.nix
  ];

  services.mautrix-signal = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.chir.rs";
        domain = "chir.rs";
        http_retry_count = 1000;
      };
      appservice = {
        max_body_size = 10;
        database = "postgres:///mautrix_signal?sslmode=disable&host=/run/postgresql";
      };
      metrics = {
        enabled = true;
        listen = "[::]:29329";
      };
      signal = {
        socket_path = config.services.signald.socketPath;
        avatar_dir = "/var/lib/signald/avatars";
        data_dir = "/var/lib/signald/data";
      };
      bridge = {
        displayname_template = "{displayname}";
        autocreate_contact_portal = true;
        public_portals = true;
        sync_with_custom_puppets = true;
        sync_direct_chat_list = true;
        encryption = {
          allow = true;
          appservice = true;
          default = true;
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
  services.postgresql.ensureUsers = [
    {
      name = "mautrix-signal";
      ensurePermissions = {
        "DATABASE mautrix_signal" = "ALL PRIVILEGES";
      };
    }
  ];
}
