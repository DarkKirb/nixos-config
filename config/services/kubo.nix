{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [../../modules/kubo.nix];
  services.kubo = {
    autoMigrate = true;
    emptyRepo = true;
    enable = true;
    enableGC = true;
    settings = {
      Addresses = {
        API = [
          "/ip4/0.0.0.0/tcp/36307"
          "/ip6/::/tcp/36307"
        ]; # Only exposed over the tailed scale
        Gateway = "/ip4/127.0.0.1/tcp/41876";
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
      Experimental = {
        FilestoreEnabled = true;
        UrlstoreEnabled = true;
      };
      Gateway.PublicGateways."ipfs.chir.rs" = {
        Paths = ["/ipfs" "/ipns"];
        UseSubdomains = false;
      };
      Peering.Peers = [
        {
          ID = "12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci";
          Addrs = [
            "/ip4/100.105.131.79/tcp/4001/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip4/100.105.131.79/udp/4001/quic-v1/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip4/100.105.131.79/udp/4001/quic-v1/webtransport/certhash/uEiDd_OUVB7F0T7MSZ8VlFKn7dwbuLLEoQv8hmN8vgrgteg/certhash/uEiCwESdZcOeKlGwbhMKId-rqkzx5uPm1z7Bs5Kw3WzJVTA/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip4/100.105.131.79/udp/4001/quic/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6269:834f/tcp/4001/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6269:834f/udp/4001/quic-v1/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6269:834f/udp/4001/quic-v1/webtransport/certhash/uEiDd_OUVB7F0T7MSZ8VlFKn7dwbuLLEoQv8hmN8vgrgteg/certhash/uEiCwESdZcOeKlGwbhMKId-rqkzx5uPm1z7Bs5Kw3WzJVTA/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6269:834f/udp/4001/quic/p2p/12D3KooWFWF4mob5DwhKGwYt1axQZiMnmTFH5oCN8JL7HA6wboci"
          ];
        }
        {
          ID = "12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW";
          Addrs = [
            "/ip4/100.99.173.107/tcp/4001/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip4/100.99.173.107/udp/4001/quic-v1/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip4/100.99.173.107/udp/4001/quic-v1/webtransport/certhash/uEiBt2eKq-XKCnuzSF96FxQBqesCUMWOMaRivMdCXQn0GCQ/certhash/uEiAqR--0diIG4VB5b47dzDEK-sh3Xfp1_2fz6bvfc37Cqg/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip4/100.99.173.107/udp/4001/quic/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/tcp/4001/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic-v1/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic-v1/webtransport/certhash/uEiBt2eKq-XKCnuzSF96FxQBqesCUMWOMaRivMdCXQn0GCQ/certhash/uEiAqR--0diIG4VB5b47dzDEK-sh3Xfp1_2fz6bvfc37Cqg/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic/p2p/12D3KooWB2C361sKMdLgRE7kJ4XvE8EcfxDz9EExUrvPmkTUApJW"
          ];
        }
      ];
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
}
