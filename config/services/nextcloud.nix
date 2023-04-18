{
  pkgs,
  config,
  ...
}: {
  services.nextcloud = {
    cache.redis = true;
    config = {
      adminpassFile = config.sops.secrets."services/nextcloud/adminpass".path;
      adminuser = "darkkirb";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      dbtype = "pgsql";
      dbuser = "nextcloud";
      defaultPhoneRegion = "DE";
      objectstore.s3 = {
        bucket = "nextcloud-chir-rs";
        enable = true;
        hostname = "s3.us-west-000.backblazeb2.com";
        key = "000decd694f9e7d0000000021";
        secretFile = config.sops.secrets."services/nextcloud/s3".path;
        usePathStyle = true;
        useSsl = true;
      };
      overwriteProtocol = "https";
    };
    enable = true;
    enableImagemagick = true;
    extraAppsEnable = true;
    extraConfig = {
      redis = {
        host = config.services.redis.servers.nextcloud.unixSocket;
        port = 0;
        dbindex = 0;
      };
    };
    hostname = "cloud.chir.rs";
    https = true;
    package = pkgs.nextcloud26;
    phpOptions = {
      "opcache.save_comments" = 1;
      "opcache.validate_timestamps" = 0;
      "opcache.jit" = 1255;
      "opcache.jit_buffer_size" = "128M";
    };
    poolSettings = {
      "pm.max_children" = 460;
    };
    webfinger = true;
    extraApps = with pkgs.nextclouud26Packages.apps; {
      inherit bookmarks calendar contacts deck files_texteditor forms groupfolders mail news notes notify_push onlyoffice polls previewgenerator spreed taskks twofactor_webauthn unsplash;
    };
  };
  sops.secrets."services/nextcloud/adminpass".owner = "nextcloud";
  sops.secrets."services/nextcloud/s3".owner = "nextcloud";
  services.redis.servers.nextcloud = {
    enable = true;
    user = "nextcloud";
  };
  services.postgresql.ensureDatabases = ["nextcloud"];
  services.postgresql.ensureUsers = [
    {
      name = "nextcloud";
      ensurePermissions = {
        "DATABASE attic" = "ALL PRIVILEGES";
      };
    }
  ];
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    listen = [
      {
        host = "127.0.0.1";
        port = 13286;
      }
    ];
  };

  services.caddy.virtualHosts."cloud.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      reverse_proxy {
          to http://127.0.0.1:13286
          header_up Host {upstream_hostport}
      }
    '';
  };
}
