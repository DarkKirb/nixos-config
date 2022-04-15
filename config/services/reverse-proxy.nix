{ ... }: {
  services.nginx.virtualHosts."hydra.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "https://hydra.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $proxy_host;
      '';
    };
  };
}
