{ pkgs, ... }: {
  systemd.services.chirrs = {
    enable = true;
    description = "chir.rs";
    script = "${pkgs.chir-rs}/chir-rs-server";
    serviceConfig = {
      WorkingDirectory = pkgs.chir-rs;
      EnvironmentFile = "/run/secrets/services/chir.rs";
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.nginx.virtualHosts."api.chir.rs" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://localhost:8621/api.chir.rs/";
    };
  };
  services.postgresql.ensureDatabases = [ "homepage" ];
  services.postgresql.ensureUsers = [{
    name = "homepage";
    ensurePermissions = { "DATABASE homepage" = "ALL PRIVILEGES"; };
  }];
  sops.secrets."services/chir.rs" = { };
}
