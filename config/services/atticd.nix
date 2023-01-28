{
  attic,
  config,
  lib,
  nix-packages,
  system,
  ...
}: {
  imports = [attic.nixosModules.atticd];
  services.atticd = {
    enable = true;
    package = nix-packages.packages.${system}.attic-server;
    credentialsFile = config.sops.secrets."services/attic".path;
    settings = {
      listen = "[::1]:57448";
      allowed-hosts = ["attic.chir.rs" "attic-nocdn.chir.rs"];
      api-endpoint = "https://attic-nocdn.chir.rs/";
      database = lib.mkForce {};
      storage = {
        type = "s3";
        region = "us-east-1";
        bucket = "attic-chir-rs";
        endpoint = "https://s3.us-west-000.backblazeb2.com/";
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
  sops.secrets."services/attic" = {};
  services.postgresql.ensureDatabases = [
    "attic"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "attic";
      ensurePermissions = {
        "DATABASE attic" = "ALL PRIVILEGES";
      };
    }
  ];
  services.caddy.virtualHosts."attic-nocdn.chir.rs" = {
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
