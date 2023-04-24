{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.wordpress.webserver = "caddy";
  services.wordpress.sites."lotte.chir.rs" = {
    settings = {
      # Needed to run behind reverse proxy
      FORCE_SSL_ADMIN = true;
    };
    extraConfig = ''
      $_SERVER['HTTPS']='on';
    '';
  };

  services.caddy.virtualHosts."lotte.chir.rs".useACMEHost = "chir.rs";
}
