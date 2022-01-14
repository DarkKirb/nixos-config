{ ... }:
{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      listenPort = 51820;
      privateKeyFile = "/run/secrets/network/wireguard/privkey";
    };
  };
}
