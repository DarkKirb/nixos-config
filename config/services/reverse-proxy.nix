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
      reverse_proxy {
        to ${dest}
        header_up Host {upstream_hostport}

        ${extra}

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
        handle {
          root * ${nix-packages.packages.${system}.mastodon}/public
          file_server
        }
        handle_errors {
          reverse_proxy {
            to https://mastodon.int.chir.rs
            header_up Host {upstream_hostport}
            transport http {
              versions 1.1 2 3
            }
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
          to https://f000.backblazeb2.com
          header_up Host {upstream_hostport}
          header_up -Authorization
          header_down -Set-Cookie
          header_down Access-Control-Allow-Origin '*'
          header_down -Access-Control-Allow-Methods
          header_down Access-Control-Allow-Headers
          header_up -Set-Cookie
          rewrite * /file/mastodon-chir-rs/{path}

          transport http {
            versions 1.1 2 3
          }
        }
      '';
    };
    "drone.chir.rs" = mkConfig "https://drone.int.chir.rs";
    "chir.rs" = {
      useACMEHost = "chir.rs";
      extraConfig = ''
        import baseConfig
        handle /.well-known/webfinger {
          header Location https://mastodon.chir.rs{path}
          respond 301
        }
      '';
    };
  };
}
