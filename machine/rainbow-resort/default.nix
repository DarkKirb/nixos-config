{
  nixos-config,
  lib,
  ...
}:
{
  networking.hostName = "rainbow-resort";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    "${nixos-config}/config/graphical.nix"
    "${nixos-config}/config/graphical/plymouth.nix"
  ];
  system.stateVersion = "24.11";
  specialisation.sfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sfw";
        isNSFW = lib.mkForce false;
      }
    ];
  };
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  isNSFW = true;
}
