{ nixos-config, lib, ... }:
{
  networking.hostName = "nas";
  networking.hostId = "70af00ed";
  environment.impermanence.enable = false;

  imports = [
    "${nixos-config}/config"
    ./hardware.nix
    "${nixos-config}/services/hydra"
  ];

  nix.settings.substituters = lib.mkForce [
    "https://attic.chir.rs/chir-rs/"
    "https://cache.nixos.org/"
  ];
}
