{ config, ... }: {
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
      };
      app_service_api.database.connection_string = "postgresql://dendrite@localhost/dendrite_app_service";
      client_api = {
        registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
      };
      federation_api = {
        database.connection_string = "postgresql://dendrite@localhost/dendrite_federation";
      };
      key_server.database.connection_string = "postgresql://dendrite@localhost/dendrite_keyserver";
    };
  };
  sops.secrets."services/dendrite/secrets" = { owner = "dendrite"; };
  services.postgresql.ensureDatabases = [
    "dendrite_app_service"
    "dendrite_federation"
    "dendrite_keyserver"
  ];
  services.postgresql.ensureUsers = [{
    name = "dendrite";
    ensurePermissions = {
      "DATABASE dendrite_app_service" = "ALL PRIVILEGES";
      "DATABASE dendrite_federation" = "ALL PRIVILEGES";
      "DATABASE dendrite_keyserver" = "ALL PRIVILEGES";
    };
  }];
}
