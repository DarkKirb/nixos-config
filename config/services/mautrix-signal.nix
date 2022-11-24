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
        address = "https://matrix.int.chir.rs";
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
      signal = {
        socket_path = config.services.signald.socketPath;
        avatar_dir = "/var/lib/mautrix-signal/avatars";
        data_dir = "/var/lib/mautrix-signal/data";
      };
      bridge = {
        displayname_template = "{displayname}";
        autocreate_contact_portal = true;
        double_puppet_allow_discovery = true;
        double_puppet_server_map = {};
        login_shared_secret_map = {};
        sync_with_custom_puppets = true;
        encryption = {
          allow = true;
          default = true;
          appservice = true;
          require = true;
          allow_key_sharing = true;
        };
        private_chat_portal_meta = true;
        delivery_receipts = true;
        delivery_error_reports = true;
        periodic_sync = 86400;
        permissions = {
          "@lotte:chir.rs" = "admin";
        };
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
