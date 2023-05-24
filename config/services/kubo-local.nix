{
  pkgs,
  config,
  lib,
  ...
}: {
  services.kubo = {
    package = pkgs.kubo-orig;
    autoMigrate = true;
    emptyRepo = true;
    enable = true;
    enableGC = true;
    settings = {
      Addresses = {
        API = [
          "/ip4/127.0.0.1/tcp/5001"
          "/ip6/::1/tcp/5001"
        ];
        Gateway = "/ip4/127.0.0.1/tcp/41876";
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

  networking.firewall.allowedTCPPorts = [
    4001
    4002
  ];
  networking.firewall.allowedUDPPorts = [
    4001
  ];
}
