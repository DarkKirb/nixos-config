{pkgs, ...}: {
  imports = [
    ../../modules/matrix/mautrix-discord.nix
  ];

  services.mautrix-discord = {
    enable = true;
    environmentFile = pkgs.emptyFile;
    settings = {
      homeserver = {
        address = "https://matrix.int.chir.rs";
        domain = "chir.rs";
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
        sync_direct_chat_list = true;
        delete_portal_on_channel_delete = true;
        encryption = {
          allow = true;
          default = false;
          require = false;
          allow_key_sharing = true;
        };
        permissions = {
          "*" = "relay";
          "@lotte:chir.rs" = "admin";
        };
        channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}} ({{.GuildName}} — {{.ParentName}}){{else}}#{{.Name}} ({{.GuildName}} — {{.ParentName}}){{end}}";
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
