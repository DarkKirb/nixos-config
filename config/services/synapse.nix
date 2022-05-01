{ lib, config, ... }: {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "chir.rs";
      public_baseurl = "https://matrix.chir.rs/";
      listeners = [{
        port = 8008;
        tls = false;
        type = "http";
        x_forwarded = true;
        bind_addresses = [ "::1" "127.0.0.1" ];
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
      admin_contact = "mailto:lotte@chir.rs";
      retention.enabled = true;
      database = {
        name = "psycopg2";
        txn_limit = 10000;
        args = {
          host = "/run/postgresql";
          user = "matrix-synapse";
          database = "synapse";
        };
      };
      enable_media_repo = false;
      url_preview_enabled = true;
      url_preview_ip_range_blacklist = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "100.64.0.0/10"
        "192.0.0.0/24"
        "169.254.0.0/16"
        "192.88.99.0/24"
        "198.18.0.0/15"
        "192.0.2.0/24"
        "198.51.100.0/24"
        "203.0.113.0/24"
        "224.0.0.0/4"
        "fe80::/10"
        "fc00::/7"
        "2001:db8::/32"
        "ff00::/8"
        "fec0::/10"
      ];
      enable_registration = false;
      app_service_config_files = [
        "/var/lib/mautrix-telegram/telegram-registration.yaml"
      ];
      signing_key_path = config.sops.secrets."services/synapse/private_key".path;
      encryption_enabled_by_default_for_room_type = "all";
    };
    withJemalloc = true;
  };
  sops.secrets."services/synapse/private_key" = { owner = "matrix-synapse"; };
  services.postgresql.ensureDatabases = [
    "synapse"
  ];
  services.postgresql.ensureUsers = [{
    name = "matrix-synapse";
    ensurePermissions = {
      "DATABASE synapse" = "ALL PRIVILEGES";
    };
  }];
}
