{ ... }:
{
  imports = [
    ./autoconfig.nix
  ];
  networking.interfaces.containers = {
    ipv6.addresses = [
      {
        address = "fdc6:e7e5:0ba1:1::1";
        prefixLength = 64;
      }
    ];
  };
  networking.bridges.containers.interfaces = [ ];
}
