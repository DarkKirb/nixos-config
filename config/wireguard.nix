{ config, ... }:
{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      listenPort = 51820;
      privateKeyFile = "/run/secrets/network/wireguard/privkey";
      peers = [
        {
          publicKey = "zQY9cAzbRO/FgV92pda7yk0NJFSXzHfi6+tgRq3g/SY=";
          allowedIPs = [
            "fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49/64"
          ];
          endpoint = "138.201.155.128:51820";
        }
        {
          publicKey = "YYQmSJwipRkZJUsPV5DxhfyRBMdj/O1XzN+cGYtUi1s=";
          allowedIPs = [
            "fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/128"
          ];
        }
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
