{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [../../modules/kubo.nix ./kubo-common.nix];
  services.kubo = {
    settings = {
      Addresses = {
        API = lib.mkForce [
          "/ip4/0.0.0.0/tcp/5001"
          "/ip6/::/tcp/5001"
        ]; # Only exposed over the tailed scale
      };
      API.HTTPHeaders = {
        Access-Control-Allow-Origin = [
          "http://bafybeic4gops3d3lyrisqku37uio33nvt6fqxvkxihrwlqsuvf76yln4fm.ipfs.localhost:41876"
          "http://localhost:3000"
          "http://127.0.0.1:5001"
          "https://webui.ipfs.io"
        ];
        Access-Control-Allow-Methods = ["PUT" "POST"];
      };
      Datastore = {
        Spec = {
          mounts = [
            {
              child = {
                type = "storjds";
                dbURI = "postgres:///kubo_storjds?sslmode=disable&host=/run/postgresql";
                bucket = "ipfs";
                nodeConnectionPoolCapacity = "100";
                nodeConnectionPoolKeyCapacity = "5";
                nodeConnectionPoolIdleExpiration = "2m";
                satelliteConnectionPoolCapacity = "10";
                satelliteConnectionPoolKeyCapacity = "0";
                satelliteConnectionPoolIdleExpiration = "2m";
              };
              mountpoint = "/";
              prefix = "storj.datastore";
              type = "measure";
            }
          ];
          type = "mount";
        };
      };
    };
  };

  sops.secrets."services/ipfs/access_grant".owner = "ipfs";
  services.postgresql.ensureDatabases = [
    "kubo_storjds"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "ipfs";
      ensurePermissions = {
        "DATABASE kubo_storjds" = "ALL PRIVILEGES";
      };
    }
  ];
  networking.firewall.allowedTCPPorts = [
    4001
    4002
  ];
  networking.firewall.allowedUDPPorts = [
    4001
  ];
  services.caddy.virtualHosts."ipfs-nocdn.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      reverse_proxy http://127.0.0.1:41876
    '';
  };
  fileSystems."/persist/var/lib/ipfs/root" = {
    device = "/";
    options = ["bind" "ro"];
  };
}
