{
  config,
  nixos-config,
  lib,
  ...
}: {
  networking.hostName = "thinkrac";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    "${nixos-config}/config/networkmanager.nix"
    "${nixos-config}/config/graphical.nix"
  ];
  system.stateVersion = "24.11";
  specialisation.quiet = {
    configuration.imports = [
      "${nixos-config}/config/graphical/plymouth.nix"
      {
        nix.auto-update.specialisation = "quiet";
      }
    ];
  };
}
