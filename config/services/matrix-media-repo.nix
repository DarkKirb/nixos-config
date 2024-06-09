{
  system,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) matrix-media-repo;
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
      {
        name = "matrix.int.chir.rs";
        csApi = "https://matrix.chir.rs";
      }
    ];
    accessTokens.maxCacheTimeSeconds = 43200;
    admins = ["@lotte:chir.rs"];
    datastores = [
      {
        type = "s3";
        id = "b003babbb86fecf56bb9ba6571f9adb0bd1e71c8";
        enabled = true;
        forKinds = ["all"];
        opts = {
          tempPath = "/var/lib/matrix-media-repo";
          endpoint = "ams1.vultrobjects.com";
          accessKeyId = "#ACCESS_KEY_ID#";
          accessSecret = "#SECRET_ACCESS_KEY#";
          ssl = true;
          bucketName = "matrix-chir-rs";
          region = "ams1";
        };
      }
    ];
    metrics = {
      enabled = true;
      bindAddress = "::";
      port = 20855;
    };
    urlPreviews = {
      enabled = true;
      numWorkers = 10;
      oEmbed = false;
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
      # user agent header was a mistake
      userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0, matrix-media-repo (like twitterbot; like telegrambot; like discordbot; like facebook; like whatsapp; like firefox/92; like vkshare) +https://github.com/DarkKirb/nixos-config/pull/264";
    };
    downloads = {
      expireAfterDays = 7;
    };
    featureSupport = {
    };
    sentry = {
      enabled = true;
      dsn = "https://18e36e6f16b5490c83364101717cddba@o253952.ingest.sentry.io/6449283";
    };
    rateLimit.enabled = false;
    thumbnails = {
      maxSourceBytes = 0;
      maxPixels = 102000000;
      types = [
        "image/jpeg"
        "image/jpg"
        "image/png"
        "image/apng"
        "image/gif"
        "image/heif"
        "image/webp"
        "image/svg+xml"
        "image/jxl"
        "audio/mpeg"
        "audio/ogg"
        "audio/wav"
        "audio/flac"
        "video/mp4"
        "video/webm"
        "video/x-matroska"
        "video/quicktime"
      ];
    };
  });
in {
  systemd.services.matrix-media-repo = {
    description = "Matrix Media Repo";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [matrix-media-repo pkgs.ffmpeg pkgs.imagemagick];
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
  systemd.services.purge-old-media = {
    path = [pkgs.curl];
    description = "Purge unused media";
    script = ''
      export MATRIX_TOKEN=$(cat ${config.sops.secrets."services/matrix-media-repo/matrix-token".path})
      for i in $(seq 1000); do
        curl -H "Authorization: Bearer $MATRIX_TOKEN" -X POST https://matrix.chir.rs/_matrix/media/unstable/admin/purge/old\?before_ts=$(date -d "3 months ago" +%s%3N)\&include_local=true && exit 0
      done
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "matrix-media-repo";
      Group = "matrix-media-repo";
    };
  };
  systemd.timers.purge-old-media = {
    description = "Purge unused media";
    after = ["network.target" "matrix-media-repo.service"];
    requires = ["purge-old-media.service"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnUnitInactiveSec = 300;
      RandomizedDelaySec = 300;
    };
  };
  sops.secrets."services/matrix-media-repo/access-key-id".owner = "matrix-media-repo";
  sops.secrets."services/matrix-media-repo/secret-access-key".owner = "matrix-media-repo";
  sops.secrets."services/matrix-media-repo/matrix-token".owner = "matrix-media-repo";
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
  services.caddy.virtualHosts."matrix.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      route {
        handle /_matrix/media/* {
          uri * replace /unstable/fi.mau.msc2246/ /v1/
          reverse_proxy http://localhost:8008 {
            header_down Access-Control-Allow-Origin *
            header_down Access-Control-Allow-Headers *
          }
        }

        handle /_matrix/client/v3/logout/* {
          reverse_proxy http://localhost:8008
        }

        handle /_matrix/* {
          reverse_proxy {
            to https://matrix.int.chir.rs
            header_up Host {upstream_hostport}

            transport http {
              versions 1.1
            }
          }
        }

        handle /.well-known/matrix/server {
          header Access-Control-Allow-Origin *
          header Content-Type application/json
          respond "{ \"m.server\": \"matrix.chir.rs:443\" }" 200
        }

        handle /.well-known/matrix/client {
          header Access-Control-Allow-Origin *
          header Content-Type application/json
          respond "{ \"m.homeserver\": { \"base_url\": \"https://matrix.chir.rs\" }, \"org.matrix.msc3575.proxy\": {\"url\": \"https://sliding-sync.chir.rs\"} }" 200
        }
      }
    '';
  };
}
