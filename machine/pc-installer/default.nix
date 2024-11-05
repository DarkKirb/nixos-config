{
  config,
  nixos-config,
  lib,
  ...
}: {
  networking.hostName = "pc-installer";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./grub.nix
    ./hardware.nix
    "${nixos-config}/config/networkmanager.nix"
  ];
  system.stateVersion = config.system.nixos.version;
  specialisation.graphical = {
    configuration.imports = [
      ./graphical.nix
    ];
  };
  nix.settings.substituters = lib.mkForce [
    "https://attic.chir.rs/chir-rs/"
    "https://hydra.chir.rs"
    "https://cache.nixos.org"
  ];
}
