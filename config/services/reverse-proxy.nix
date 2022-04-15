{ ... }: {
  services.nginx.virtualHosts."hydra.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "https://hydra.int.chir.rs";
      proxyWebsockets = true;
    };
  };
}
