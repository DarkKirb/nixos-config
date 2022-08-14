{ pkgs, invtracker, ... }:
  let
    port = 19689;
    configFile = builtins.toFile "config.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <config>
      <server host="127.0.0.1" port="${toString port}" />
      <database url="jdbc:sqlite:test.db />
    </config>
  '';
  in {
    systemd.services.invtracker = {
      enable = true;
      description = "InvTracker";
      script = "${invtracker.packages.${pkgs.system}.invtracker-server}/bin/server ${configFile}";
      serviceConfig = {
        User = "invtracker";
        Group = "invtracker";
        WorkingDirectory = "/var/lib/invtracker";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
      environment = {
        JAVA_HOME = "${pkgs.openjdk_headless}";
      };
    };
    services.nginx.virtualHosts."invtracker.chir.rs" = {
      sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
      sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
      locations."/" = {
        proxyPass = "http://localhost:${toString port}/";
      };
    };
    users.users.invtracker = {
      description = "InvTracker";
      home = "/var/lib/invtracker";
      useDefaultShell = true;
      group = "invtracker";
      isSystemUser = true;
    };
    users.groups.invtracker = {};
    systemd.tmpfiles.rules = [
      "d '/var/lib/invtracker' 0750 invtracker invtracker - -"
    ];
  }
