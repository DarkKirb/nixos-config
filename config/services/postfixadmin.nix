{ ... }: {
  services.postfixadmin = {
    enable = true;
    adminEmail = "lotte@chir.rs";
    database = {
      dbname = "postfix";
      host = "localhost";
      passwordFile = "/run/secrets/services/postfixadmin/dbpassword";
      username = "postfixadmin";
    };
    hostName = "mail.chir.rs";
    setupPasswordFile = "/run/secrets/services/postfixadmin/setupPassword";
  };
  sops.secrets."services/postfixadmin/dbpassword" = {
    owner = "postfixadmin";
  };
  sops.secrets."services/postfixadmin/setupPassword" = {
    owner = "postfixadmin";
  };
  services.postgresql.ensureDatabases = [ "postfix" ];
  services.postgresql.ensureUsers = [
    {
      name = "postfixadmin";
      ensurePermissions = {
        "DATABASE \"postfix\"" = "ALL PRIVILEGES";
      };
    }
  ];
  services.nginx.virtualHosts."mail.chir.rs" = {
    forceSSL = true;
    http2 = true;
    listenAddresses = [ "0.0.0.0" "[::]" ];
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
  };
  services.phpfpm.pools.postfixadmin.settings."listen.group" = "acme"; # there is no nginx group
}
