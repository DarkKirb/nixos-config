{
  attic,
  config,
  lib,
  system,
  ...
}:
{
  disabledModules = [ "services/networking/atticd.nix" ];
  imports = [ attic.nixosModules.atticd ];
  services.atticd = {
    enable = true;
    package = attic.packages.${system}.attic-server;
    credentialsFile = config.sops.secrets."services/atticd/credentials".path;
    settings = {
      listen = "[::1]:57448";
      allowed-hosts = [ "attic.chir.rs" ];
      api-endpoint = "https://attic.chir.rs/";
      storage = {
        type = "s3";
        region = "us-east-1";
        bucket = "attic-chir-rs";
        endpoint = "https://ams1.vultrobjects.com/";
      };
      compression = {
        type = "zstd";
        level = 12;
      };
      chunking = {
        nar-size-threshold = 131072;
        min-size = 65536;
        avg-size = 131072;
        max-size = 262144;
      };
      garbage-collection.default-retention-period = "3 months";
    };
  };
  sops.secrets."services/atticd/credentials".sopsFile = ./secrets.yaml;
  services.pgbouncer.settings.databases = {
    attic = "host=127.0.0.1 port=5432 auth_user=attic dbname=attic";
  };
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "attic";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "attic" ];
  };
  services.caddy.virtualHosts."attic.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://[::1]:57448 {
        trusted_proxies private_ranges
      }
    '';
  };
}
