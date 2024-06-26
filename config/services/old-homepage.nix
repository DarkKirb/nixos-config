{
  system,
  pkgs,
  ...
}: let
  inherit (pkgs) old-homepage;
in {
  systemd.services.homepage-old = {
    enable = true;
    description = "darkkirb.de";
    script = "${old-homepage}/homepage";
    serviceConfig = {
      WorkingDirectory = old-homepage;
      EnvironmentFile = "/run/secrets/services/old-homepage";
    };
    wantedBy = ["multi-user.target"];
  };
  services.caddy.virtualHosts."darkkirb.de" = {
    useACMEHost = "darkkirb.de";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy {
        to http://localhost:3002
        trusted_proxies private_ranges
      }
    '';
  };
  services.caddy.virtualHosts."static.darkkirb.de" = {
    useACMEHost = "darkkirb.de";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      rewrite * /file/darkkirb-de{path}

      reverse_proxy {
        to https://f000.backblazeb2.com
        header_up Host {upstream_hostport}

        transport http {
          versions 1.1
        }
      }
    '';
  };
  sops.secrets."services/old-homepage" = {};
}
