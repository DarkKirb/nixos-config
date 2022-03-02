{ ... }: {
  imports = [
    (import ../../modules/gateway-st.nix {
      name = "nix-cache";
      port = 7778;
    })
  ];
  services.nginx.virtualHosts."cache.int.chir.rs" = {
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://localhost:7778/";
      proxyWebsockets = true;
    };
  };
}
