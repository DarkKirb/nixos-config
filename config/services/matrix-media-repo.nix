{
  nix-packages,
  system,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (nix-packages.packages.${system}) matrix-media-repo;
  config-yml = pkgs.writeText "matrix-media-repo.yaml" (lib.generators.toYAML {} {
    repo = {
      bindAddress = "127.0.0.1";
      port = 8008;
      logDirectory = "-";
    };
    database.postgres = "postgresql:///matrix_media_repo?sslmode=disable&host=/run/postgresql";
    homeservers = [
      {
        name = "matrix.chir.rs";
        csApi = "https://matrix.chir.rs";
      }
    ];
    admins = ["@lotte:chir.rs"];
    datastores = [
      {
        type = "s3";
        enabled = true;
        forKinds = ["all"];
        opts = {
          tempPath = "/tmp/mediarepo_s3_upload";
          endpoint = "s3.us-west-000.backblazeb2.com";
          accessKeyId = "#ACCESS_KEY_ID#";
          accessSecret = "#SECRET_ACCESS_KEY#";
          ssl = true;
          bucketName = "matrix-chir-rs";
          region = "us-west-000";
        };
      }
    ];
    metrics = {
      enabled = true;
      bindAddress = "::";
      port = 9000;
    };
    urlPreviews = {
      enabled = true;
      numWorkers = 10;
      oEmbed = true;
      allowedNetworks = [
        "0.0.0.0/0"
        "::/0"
      ];
      disallowedNetworks = [
        "127.0.0.1/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "::1/128"
        "fe80::/64"
        "fc00::/7"
      ];
      userAgent = "TelegramBot (like TwitterBot)"; # to make it work with fxtwitter/vxtwitter
    };
    downloads = {
      expireAfterDays = 7;
    };
    featureSupport = {
      MSC2448.enabled = true;
      MSC2246 = {
        enabled = true;
        asyncUploadExpirySecs = 120;
      };
    };
    sentry = {
      enable = true;
      dsn = "https://18e36e6f16b5490c83364101717cddba@o253952.ingest.sentry.io/6449283";
    };
  });
in {
  networking.firewall.interfaces."wg0".allowedTCPPorts = [9000];
  systemd.services.matrix-media-repo = {
    description = "Matrix Media Repo";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [matrix-media-repo];
    preStart = ''
      akid=$(cat ${config.sops.secrets."services/matrix-media-repo/access-key-id".path})
      sak=$(cat ${config.sops.secrets."services/matrix-media-repo/secret-access-key".path})
      cat ${config-yml} > /var/lib/matrix-media-repo/config.yml
      sed -i "s|#ACCESS_KEY_ID#|$akid|g" /var/lib/matrix-media-repo/config.yml
      sed -i "s|#SECRET_ACCESS_KEY#|$sak|g" /var/lib/matrix-media-repo/config.yml
    '';
    serviceConfig = {
      Type = "simple";
      User = "matrix-media-repo";
      Group = "matrix-media-repo";
      Restart = "always";
      ExecStart = "${matrix-media-repo}/bin/media_repo -config /var/lib/matrix-media-repo/config.yml";
    };
  };
  sops.secrets."services/matrix-media-repo/access-key-id".owner = "matrix-media-repo";
  sops.secrets."services/matrix-media-repo/secret-access-key".owner = "matrix-media-repo";
  users.users.matrix-media-repo = {
    description = "Matrix Media Repository";
    home = "/var/lib/matrix-media-repo";
    useDefaultShell = true;
    group = "matrix-media-repo";
    isSystemUser = true;
  };
  users.groups.matrix-media-repo = {};
  systemd.tmpfiles.rules = [
    "d '/var/lib/matrix-media-repo' 0750 matrix-media-repo matrix-media-repo - -"
  ];
  services.postgresql.ensureDatabases = [
    "matrix_media_repo"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "matrix-media-repo";
      ensurePermissions = {
        "DATABASE matrix_media_repo" = "ALL PRIVILEGES";
      };
    }
  ];
  services.nginx.virtualHosts."matrix.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/_matrix" = {
      proxyPass = "https://matrix.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_server_name on;
        proxy_hide_header Access-Control-Allow-Origin;
        add_header Access-Control-Allow-Origin '*' always;
      '';
    };
    locations."/_matrix/media" = {
      proxyPass = "http://localhost:8008";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_hide_header Access-Control-Allow-Origin;
        add_header Access-Control-Allow-Origin '*' always;
      '';
    };
    locations."/.well-known/matrix/server" = {
      extraConfig = ''
        return 200 '{ "m.server": "matrix.chir.rs:443" }';
      '';
    };
    locations."/.well-known/matrix/client" = {
      extraConfig = ''
        add_header Access-Control-Allow-Origin '*';
        return 200 '{ "m.homeserver": { "base_url": "https://matrix.chir.rs" } }';
      '';
    };
    locations."/_synapse/metrics" = {
      extraConfig = ''
        return 404 'Not found';
      '';
    };
  };
  services.nginx.virtualHosts."chir.rs" = {
    locations."/.well-known/matrix/server" = {
      extraConfig = ''
        return 200 '{ "m.server": "matrix.chir.rs:443" }';
      '';
    };
    locations."/.well-known/matrix/client" = {
      extraConfig = ''
        add_header Access-Control-Allow-Origin '*';
        return 200 '{ "m.homeserver": { "base_url": "https://matrix.chir.rs" } }';
      '';
    };
  };
}
