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
    #"${nixos-config}/config/graphical/plymouth.nix"
  ];
  system.stateVersion = "24.11";
  specialisation.sway = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sway";
        isSway = true;
      }
    ];
  };
  specialisation.sfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sfw";
        isNSFW = lib.mkForce false;
      }
    ];
  };
  specialisation.sway-sfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sway-sfw";
        isSway = true;
        isNSFW = lib.mkForce false;
      }
    ];
  };
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  isNSFW = true;
}
