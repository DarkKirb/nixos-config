{
  pkgs,
  config,
  lib,
  ...
}: {
  services.kubo = {
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
          ID = "12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE";
          Addrs = [
            "/ip4/100.99.173.107/tcp/4001/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip4/100.99.173.107/udp/4001/quic-v1/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip4/100.99.173.107/udp/4001/quic-v1/webtransport/certhash/uEiBBlhb66XtCUiqnm_MRhw9dXBDdQPw_cyXSqGfLXPGZZw/certhash/uEiA6S2rO5xyLpJ_Nz4nwuLHBaiwhFGIUbQ-g0Wjm3fAZzA/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip4/100.99.173.107/udp/4001/quic/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/tcp/4001/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic-v1/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic-v1/webtransport/certhash/uEiBBlhb66XtCUiqnm_MRhw9dXBDdQPw_cyXSqGfLXPGZZw/certhash/uEiA6S2rO5xyLpJ_Nz4nwuLHBaiwhFGIUbQ-g0Wjm3fAZzA/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b/udp/4001/quic/p2p/12D3KooWAFmukGRVqg54X97xzd2j1DvUzWQYUWx9Xbi6DQhai7uE"
          ];
        }
        {
          ID = "12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq";
          Addrs = [
            "/ip4/100.99.129.7/tcp/4001/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip4/100.99.129.7/udp/4001/quic-v1/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip4/100.99.129.7/udp/4001/quic-v1/webtransport/certhash/uEiDKdsFwl7AmtSQbXYxX-BZzbFpKbyAoVDPH1L4_r0OpFQ/certhash/uEiABeqMxri7X_qWstcpG8Ga1rpQ-P_nr-5AHhd2esVB7eQ/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip4/100.99.129.7/udp/4001/quic/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:8107/tcp/4001/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:8107/udp/4001/quic-v1/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:8107/udp/4001/quic-v1/webtransport/certhash/uEiDKdsFwl7AmtSQbXYxX-BZzbFpKbyAoVDPH1L4_r0OpFQ/certhash/uEiABeqMxri7X_qWstcpG8Ga1rpQ-P_nr-5AHhd2esVB7eQ/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:6263:8107/udp/4001/quic/p2p/12D3KooWHY9DrTbuUe1gznxC8AYnX6TWmB3zBeTfA3MP4xFT67Vq"
          ];
        }
        {
          ID = "12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg";
          Addrs = [
            "/ip4/100.75.9.4/tcp/4001/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip4/100.75.9.4/udp/4001/quic-v1/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip4/100.75.9.4/udp/4001/quic-v1/webtransport/certhash/uEiBVo-LYcJSM7AP1AfCT-6U1n0-YofIx79YEabL4OxSTNA/certhash/uEiDpXKor0LPuUqEiuvXuFo4SGs2_VQxtIV1Lg6MNVC9R1w/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip4/100.75.9.4/udp/4001/quic/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:624b:904/tcp/4001/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:624b:904/udp/4001/quic-v1/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:624b:904/udp/4001/quic-v1/webtransport/certhash/uEiBVo-LYcJSM7AP1AfCT-6U1n0-YofIx79YEabL4OxSTNA/certhash/uEiDpXKor0LPuUqEiuvXuFo4SGs2_VQxtIV1Lg6MNVC9R1w/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
            "/ip6/fd7a:115c:a1e0:ab12:4843:cd96:624b:904/udp/4001/quic/p2p/12D3KooWNcWmCrzEEN4EmoRWjDfP6oZqCB3Lr14sfzy3wfjX73kg"
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
