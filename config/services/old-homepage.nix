{
  nix-packages,
  system,
  ...
}: let
  inherit (nix-packages.packages.${system}) old-homepage;
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
    extraConfig = ''
      import baseConfig

      rewrite * /file/darkkirb-de{path}

      reverse_proxy {
        to https://f000.backblazeb2.com
        header_up Host {upstream_hostport}

        transport http {
          versions 1.1 2 3
        }
      }
    '';
  };
  sops.secrets."services/old-homepage" = {};
}
