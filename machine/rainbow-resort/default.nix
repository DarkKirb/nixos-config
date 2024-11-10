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
  specialisation.sfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sfw";
        isNSFW = lib.mkForce false;
      }
    ];
  };
  specialisation.quiet-sfw = {
    configuration.imports = [
      "${nixos-config}/config/graphical/plymouth.nix"
      {
        nix.auto-update.specialisation = "quiet-sfw";
        isNSFW = lib.mkForce false;
      }
    ];
  };
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  isNSFW = true;
}
