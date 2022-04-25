{ config, ... }: {
  services.nginx.virtualHosts."hydra.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "https://nas.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_server_name on;
      '';
    };
  };
  services.nginx.virtualHosts."mastodon.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    root = "${config.services.mastodon.package}/public/"; # for spood
    locations."/" = {
      tryFiles = "$uri @proxy";
    };
    locations."@proxy" = {
      proxyPass = "https://nas.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_server_name on;
      '';
    };
    extraConfig = ''
      proxy_set_header Host "mastodon.chir.rs";
    '';
  };
}
