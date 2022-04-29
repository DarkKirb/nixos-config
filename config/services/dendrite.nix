{ lib, config, ... }: {
  services.dendrite = {
    enable = true;
    environmentFile = config.sops.secrets."services/dendrite/secrets".path;
    settings = {
      global = {
        server_name = "chir.rs";
        trusted_third_party_id_servers = [
          "matrix.org"
          "vector.im"
        ];
        presence = {
          enable_inbound = true;
          enable_outbound = true;
        };
        private_key = config.sops.secrets."services/dendrite/private_key".path;
      };
      app_service_api.database.connection_string = "postgresql:///dendrite_app_service";
      client_api = {
        registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
      };
      federation_api = {
        database.connection_string = "postgresql:///dendrite_federation";
      };
      key_server.database.connection_string = "postgresql:///dendrite_keyserver";
      media_api.database.connection_string = "postgrestql:///dendrite_mediaapi";
      mscs = {
        mscs = [ "msc2836" "msc2946" ];
        database.connection_string = "postgresql:///dendrite_mscs";
      };
      room_server.database.connection_string = "postgresql:///dendrite_roomserver";
      sync_api.database.connection_string = "postgresql:///dendrite_syncapi";
      user_api.database.connection_string = "postgresql:///dendrite_userapi";
    };
  };
  sops.secrets."services/dendrite/secrets" = { owner = "dendrite"; };
  sops.secrets."services/dendrite/private_key" = { owner = "dendrite"; };
  services.postgresql.ensureDatabases = [
    "dendrite_app_service"
    "dendrite_federation"
    "dendrite_keyserver"
    "dendrite_mediaapi"
    "dendrite_mscs"
    "dendrite_roomserver"
    "dendrite_syncapi"
    "dendrite_userapi"
  ];
  services.postgresql.ensureUsers = [{
    name = "dendrite";
    ensurePermissions = {
      "DATABASE dendrite_app_service" = "ALL PRIVILEGES";
      "DATABASE dendrite_federation" = "ALL PRIVILEGES";
      "DATABASE dendrite_keyserver" = "ALL PRIVILEGES";
      "DATABASE dendrite_mediaapi" = "ALL PRIVILEGES";
      "DATABASE dendrite_mscs" = "ALL PRIVILEGES";
      "DATABASE dendrite_roomserver" = "ALL PRIVILEGES";
      "DATABASE dendrite_syncapi" = "ALL PRIVILEGES";
      "DATABASE dendrite_userapi" = "ALL PRIVILEGES";
    };
  }];
  systemd.services.dendrite.serviceConfig = {
    User = "dendrite";
    Group = "dendrite";
    DynamicUser = lib.mkForce false;
  };
  users.users.dendrite = {
    description = "Matrix Media Repository";
    home = "/var/lib/dendrite";
    useDefaultShell = true;
    group = "dendrite";
    isSystemUser = true;
  };
  users.groups.dendrite = { };
  services.nginx.virtualHosts =
    let
      listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
      listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
        add_header Alt-Svc 'h3=":443"';
      '';
      dendrite = {
        listenAddresses = listenIPs;
        locations."/_matrix" = {
          proxyPass = "http://localhost:8008";
        };
      };
    in
    {
      "matrix.chir.rs" = dendrite // {
        sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
      };
      "matrix.int.chir.rs" = dendrite // {
        sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
      };
    };
}
