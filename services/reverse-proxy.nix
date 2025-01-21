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
      '';
    };
  };
}
