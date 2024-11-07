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
      "${nixos-config}/config/graphical/plymouth.nix"
    ];
  };
  specialisation.graphical-verbose = {
    configuration.imports = [
      ./graphical.nix
    ];
  };
  isInstaller = true;
}
