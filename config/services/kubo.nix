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
          "http://bafybeiamycmd52xvg6k3nzr6z3n33de6a2teyhquhj4kspdtnvetnkrfim.ipfs.localhost:41876"
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
                type = "s3ds";
                region = "ams1";
                bucket = "ipfs-chir-rs";
                rootDirectory = "/";
                regionEndpoint = "ams1.vultrobjects.com";
              };
              mountpoint = "/blocks";
              prefix = "s3.datastore";
              type = "measure";
            }
            {
                child = {
                    compression = "none";
                    path = "datastore";
                    type = "levelds";
                };
                mountpoint = "/";
                prefix = "leveldb.datastore";
                type = "measure";
            }
          ];
          type = "mount";
        };
      };
    };
  };

  sops.secrets."services/ipfs/accessKey".owner = "ipfs";
  sops.secrets."services/ipfs/secretKey".owner = "ipfs";
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
