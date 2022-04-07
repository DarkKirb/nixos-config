{ config, ... }:
{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      listenPort = 51820;
      privateKeyFile = "/run/secrets/network/wireguard/privkey";
      peers = [
        # nixos-8gb-fsn1-1
        {
          publicKey = "zQY9cAzbRO/FgV92pda7yk0NJFSXzHfi6+tgRq3g/SY=";
          allowedIPs = [
            "fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49/64"
          ];
          endpoint = "138.201.155.128:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
  sops.secrets."network/wireguard/privkey" = { };
}
