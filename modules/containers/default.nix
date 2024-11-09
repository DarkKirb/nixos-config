{
  nixos-config,
  lib,
  ...
}:
{
  imports = [
    nixos-config.nixosModules.default
    ./hostName.nix
    ./minimize.nix
  ];

  networking.hostName = lib.mkOverride 1100 "container";
  boot.isContainer = true;
}
