{
  pkgs,
  lib,
  config,
  ...
}: {
  services.matrix-synapse = {
    enable = true;
    settings = {
      app_service_config_files = [
        config.sops.secrets."synapse/mautrix-discord".path
        config.sops.secrets."synapse/mautrix-signal".path
        config.sops.secrets."synapse/mautrix-telegram".path
        config.sops.secrets."synapse/mautrix-whatsapp".path
      ];
      server_name = "chir.rs";
      public_baseurl = "https://matrix.chir.rs/";
      default_room_version = 10;
      listeners = [
        {
          port = 8008;
          tls = false;
          type = "http";
          x_forwarded = true;
          bind_addresses = ["::1" "127.0.0.1"];
          resources = [
            {
              names = ["client" "federation" "metrics"];
              compress = false;
            }
          ];
        }
      ];
      admin_contact = "mailto:lotte@chir.rs";
      retention = {
        enabled = true;
        default_policy = {
          max_lifetime = "12w";
        };
        max_lifetime = "12w";
        allowed_lifetime_max = "12w";
        purge_jobs = [
          {
            longest_max_lifetime = "3d";
            interval = "12h";
          }
          {
            shortest_max_lifetime = "3d";
            interval = "1d";
          }
        ];
      };
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
      signing_key_path = config.sops.secrets."services/synapse/private_key".path;
      enable_metrics = true;
      encryption_enabled_by_default_for_room_type = "all";
      experimental_features = {
        msc3026_enabled = true;
        msc2716_enabled = true;
        msc3244_enabled = true;
        msc3266_enabled = true;

        msc2409_to_device_messages_enabled = true;
        msc3202_device_masquerading_enabled = true;
        msc3202_transaction_extensions = true;
        msc3706_enabled = true;
        faster_joins_enabled = true;
        msc3720_enabled = true;
        msc2654_enabled = true;
        msc2815_enabled = true;
        msc3391_enabled = true;
        msc3773_enabled = true;
        msc3664_enabled = true;
        msc3848_enabled = true;
        msc3852_enabled = true;
        msc3881_enabled = true;
        msc3882_enabled = true;
        msc3874_enabled = true;
        msc3890_enabled = true;
        msc3381_polls_enabled = true;
        msc3912_enabled = true;
        msc1767_enabled = true;
        msc3952_intentional_mentions = true;
        msc3958_supress_edit_notifs = true;
        msc3967_enabled = true;
        msc2659_enabled = true;
      };
      #sentry.dsn = "https://18e36e6f16b5490c83364101717cddba@o253952.ingest.sentry.io/6449283";
    };
    withJemalloc = true;
  };
  sops.secrets."services/synapse/private_key" = {owner = "matrix-synapse";};
  services.postgresql.ensureDatabases = [
    "synapse"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "matrix-synapse";
      ensurePermissions = {
        "DATABASE synapse" = "ALL PRIVILEGES";
      };
    }
  ];
  systemd.services.matrix-synapse.serviceConfig.ExecStartPre = lib.mkForce (pkgs.writeShellScript "dummy" "true");

  services.caddy.virtualHosts."matrix.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      handle /_matrix/* {
        reverse_proxy localhost:8008 {
          trusted_proxies private_ranges
        }
      }
      handle /_synapse/* {
        reverse_proxy localhost:8008 {
          trusted_proxies private_ranges
        }
      }
      handle /_matrix/media/* {
        reverse_proxy {
          to https://matrix.chir.rs
          trusted_proxies private_ranges

          header_up Host {upstream_hostport}

          transport http {
            versions 1.1 2 3
          }
        }
      }
    '';
  };

  services.caddy.virtualHosts."matrix-admin.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      root * ${pkgs.synapse-admin}
      file_server
    '';
  };

  sops.secrets."synapse/mautrix-discord" = {
    key = "services/mautrix/discord.yaml";
    owner = "matrix-synapse";
  };
  sops.secrets."synapse/mautrix-signal" = {
    key = "services/mautrix/signal.yaml";
    owner = "matrix-synapse";
  };
  sops.secrets."synapse/mautrix-telegram" = {
    key = "services/mautrix/telegram.yaml";
    owner = "matrix-synapse";
  };
  sops.secrets."synapse/mautrix-whatsapp" = {
    key = "services/mautrix/whatsapp.yaml";
    owner = "matrix-synapse";
  };
}
