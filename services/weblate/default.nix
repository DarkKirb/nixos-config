{ lib, config, ... }:
{
  services.weblate = {
    enable = true;
    djangoSecretKeyFile = config.sops.secrets."services/weblate/djangoSecretKey".path;
    localDomain = "weblate.chir.rs";
  };
  sops.secrets."services/weblate/djangoSecretKey" = {
    sopsFile = ./secrets.yaml;
    owner = "weblate";
  };
  services.caddy.virtualHosts."weblate.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig

      handle_path /favicon.ico {
        root ${config.services.weblate.package}/${config.services.weblate.package.python.sitePackages}/weblate/static
        try_files /favicon.ico =404
        file_server
      }
      handle_path /static/* {
        root ${config.services.weblate.package.static}
        file_server
      }
      handle_path /media/* {
        root /var/lib/weblate/media/
        file_server
      }

      reverse_proxy unix//run/weblate.socket {
        header_up X-Real-Ip {remote_host}
      }
    '';
  };

  users.groups.weblate.members = [ "caddy" ];
  services.nginx.enable = lib.mkForce false;
}
