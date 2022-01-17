{ ... }: {
  services.nginx.virtualHosts."static.darkkirb.de" = {
    addSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/darkkirb.de/cert.pem";
    sslCertificateKey = "/var/lib/acme/darkkirb.de/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000/darkkirb.de/";
    };
  };
}
