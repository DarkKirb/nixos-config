{
  nix-packages,
  system,
  pkgs,
  config,
  ...
}: let
  mkConfigExtra = extra: dest: {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      ${extra}

      reverse_proxy {
        to ${dest}
        header_up Host {upstream_hostport}

        transport http {
          versions 1.1 2 3
        }
      }
    '';
  };
  mkConfig = mkConfigExtra "";
in {
  services.caddy.virtualHosts = {
    "hydra.chir.rs" = mkConfig "https://hydra.int.chir.rs";
    "mastodon.chir.rs" = {
      useACMEHost = "chir.rs";
      extraConfig = ''
        import baseConfig
          reverse_proxy {
            to https://mastodon.int.chir.rs
            header_up Host {upstream_hostport}
            transport http {
              versions 1.1 2 3
            }
        }
      '';
    };
    "mastodon-assets.chir.rs" = {
      useACMEHost = "chir.rs";
      extraConfig = ''
        import baseConfig
        @getOnly {
          method GET
        }

        reverse_proxy @getOnly {
          to http://localhost:24155
          header_up Host {upstream_hostport}
          header_up -Authorization
          header_down -Set-Cookie
          header_down Access-Control-Allow-Origin '*'
          header_down -Access-Control-Allow-Methods
          header_down Access-Control-Allow-Headers
          header_up -Set-Cookie

          transport http {
            versions 1.1 2 3
          }
        }
      '';
    };
    "cache.chir.rs" = {
      useACMEHost = "chir.rs";
      extraConfig = ''
        import baseConfig
        @getOnly {
          method GET
        }

        reverse_proxy @getOnly {
          to http://localhost:24156
          header_up Host {upstream_hostport}
          header_up -Authorization
          header_down -Set-Cookie
          header_down Access-Control-Allow-Origin '*'
          header_down -Access-Control-Allow-Methods
          header_down Access-Control-Allow-Headers
          header_up -Set-Cookie

          transport http {
            versions 1.1 2 3
          }
        }
      '';
    };
    "drone.chir.rs" = mkConfig "https://drone.int.chir.rs";
    "moa.chir.rs" = mkConfig "https://moa.int.chir.rs";
    "chir.rs" = {
      useACMEHost = "chir.rs";
      extraConfig = ''
        import baseConfig
        handle /.well-known/webfinger {
          header Location https://mastodon.chir.rs{path}
          respond 301
        }
        handle /.well-known/matrix/server {
          header Access-Control-Allow-Origin *
          header Content-Type application/json
          respond "{ \"m.server\": \"matrix.chir.rs:443\" }" 200
        }

        handle /.well-known/matrix/client {
          header Access-Control-Allow-Origin *
          header Content-Type application/json
          respond "{ \"m.homeserver\": { \"base_url\": \"https://matrix.chir.rs\" } }" 200
        }
      '';
    };
  };
  services.nginx.virtualHosts."mastodon-assets.chir.rs" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 24155;
      }
    ];
    extraConfig = ''
      limit_except GET {
        deny all;
      }
      proxy_set_header Authorization ${"''"};
      proxy_hide_header Set-Cookie;
      proxy_hide_header 'Access-Control-Allow-Origin';
      proxy_hide_header 'Access-Control-Allow-Methods';
      proxy_hide_header 'Access-Control-Allow-Headers';
      proxy_ignore_headers Set-Cookie;
      proxy_intercept_errors off;
      proxy_cache        akkoma_media_cache;
      proxy_cache_key    $host$uri$is_args$args;
      proxy_cache_valid 200 48h;
      proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
      proxy_cache_lock on;
      expires 1y;
      add_header Cache-Control public;
      add_header 'Access-Control-Allow-Origin' '*';
      add_header X-Cache-Status $upstream_cache_status;
    '';
    proxyPass = "https://f000.backblazeb2.com/file/mastodon-chir-rs/";
  };
  services.nginx.virtualHosts."cache.chir.rs" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 24155;
      }
    ];
    extraConfig = ''
      limit_except GET {
        deny all;
      }
      proxy_set_header Authorization ${"''"};
      proxy_hide_header Set-Cookie;
      proxy_hide_header 'Access-Control-Allow-Origin';
      proxy_hide_header 'Access-Control-Allow-Methods';
      proxy_hide_header 'Access-Control-Allow-Headers';
      proxy_ignore_headers Set-Cookie;
      proxy_intercept_errors off;
      proxy_cache        akkoma_media_cache;
      proxy_cache_key    $host$uri$is_args$args;
      proxy_cache_valid 200 48h;
      proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
      proxy_cache_lock on;
      expires 1y;
      add_header Cache-Control public;
      add_header 'Access-Control-Allow-Origin' '*';
      add_header X-Cache-Status $upstream_cache_status;
    '';
    proxyPass = "https://f000.backblazeb2.com/file/cache-chir-rs/";
  };
}
