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
        async_media = true;
      };
      appservice = {
        database = {
          type = "postgres";
          uri = "postgres:///mautrix_discord?sslmode=disable&host=/run/postgresql";
        };
      };
      metrics = {
        enabled = true;
        listen = "[::]:29321";
      };
      bridge = {
        delivery_receipts = true;
        double_puppet_server_map = {};
        login_shared_secret_map = {};
        private_chat_portal_meta = true;
        encryption = {
          allow = true;
        };
        permissions = {
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
