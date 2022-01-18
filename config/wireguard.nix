{ ... }:
{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      listenPort = 51820;
      privateKeyFile = "/run/secrets/network/wireguard/privkey";
      peers = [
        # Old infra: ubuntu-4gb-fsn1-1
        {
          publicKey = "ZtU2iWwVYeGyXC1ak+wFdTuisQNq7gMthYQZaw6InDU=";
          endpoint = "23.88.44.119:51820";
          allowedIPs = [
            "fd00:e621:e621::/64"
            "fd00:e621:e621:1::/64"
            "fd00:e621:e621:2::3/128"
          ];
        }
        # Old infra: nas
        {
          publicKey = "X6IOz4q4zfPy34bRhAjsureLc6lLFOSwvyGDfxgp8n4=";
          allowedIPs = [
            "fd00:e621:e621:2::2/128"
          ];
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
  sops.secrets."network/wireguard/privkey" = { };
}
