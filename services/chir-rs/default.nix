{
  lib,
  pkgs,
  config,
  chir-rs,
  system,
  nixos-config,
  ...
}:
let
  configFile = (pkgs.formats.toml { }).generate "config.toml" {
    cache_max_size = 16000000;
    paseto_secret_key_file = config.sops.secrets."services/chir-rs/paseto-secret-key".path;
    logging = {
      sentry_dsn = "https://c9d12e36a24cf7cd7addfff060884d0d@o253952.ingest.us.sentry.io/4508341406793728";
    };
    http = {
      listen = "[::]:5621";
    };
    gemini = {
      host = "lotte.chir.rs";
      private_key = "/var/lib/acme/chir.rs/key.pem";
      certificate = "/var/lib/acme/chir.rs/cert.pem";
    };
    s3 = {
      endpoint = "https://ams1.vultrobjects.com/";
      region = "us-east-1";
      access_key_id_file = config.sops.secrets."services/chir-rs/access-key-id".path;
      secret_access_key_file = config.sops.secrets."services/chir-rs/secret-access-key".path;
      bucket = "chir-rs";
    };
    database.path = config.sops.secrets."services/chir-rs/database-url".path;
  };
in
{
  imports = [
    "${nixos-config}/services/acme"
  ];
  security.acme.enable = true;
  systemd.services.chir-rs = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      User = "chir-rs";
      Group = "acme";
      ExecStart = lib.getExe' chir-rs.packages.${system}.chir-rs "chir-rs";
    };
    environment = {
      CHIR_RS_CONFIG = "${configFile}";
    };
  };
  sops.secrets."services/chir-rs/paseto-secret-key" = {
    owner = "chir-rs";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/chir-rs/access-key-id" = {
    owner = "chir-rs";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/chir-rs/secret-access-key" = {
    owner = "chir-rs";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."services/chir-rs/database-url" = {
    owner = "chir-rs";
    sopsFile = ./secrets.yaml;
  };
  services.postgresql.ensureDatabases = [
    "chir_rs"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "chir_rs";
      ensureDBOwnership = true;
    }
  ];
  users.users.chir-rs = {
    description = "Chir.rs domain server";
    isSystemUser = true;
    group = "chir-rs";
  };
  users.groups.chir-rs = { };
  services.caddy.virtualHosts."lotte.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy {
        to http://instance-20221213-1915.int.chir.rs:5621 http://nixos-8gb-fsn1-1.int.chir.rs:5621 http://nas.int.chir.rs:5621
        trusted_proxies private_ranges
        lb_retries 3
        lb_try_duration 2s
        health_uri /.api/readyz
        header_up Host {upstream_hostport}
      }
    '';
  };
}
