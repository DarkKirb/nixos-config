{ nixos-config, ... }:
{
  imports = [
    nixos-config.nixosModules.containers
  ];
}
