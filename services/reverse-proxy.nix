{
  pkgs,
  ...
}:
let
  mkConfigExtra = extra: dest: {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      ${extra}

      reverse_proxy {
        to ${dest}
        header_up Host {upstream_hostport}

        transport http {
          versions 1.1
        }
      }
    '';
  };
  mkConfig = mkConfigExtra "";
in
{
  services.caddy.virtualHosts = {
    "hydra.chir.rs" = mkConfig "https://hydra.int.chir.rs";
    "chir.rs" = {
      useACMEHost = "chir.rs";
      logFormat = pkgs.lib.mkForce "";
      extraConfig = ''
        import baseConfig
        handle /.well-known/webfinger {
          header Location https://akko.chir.rs{path}
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
}
