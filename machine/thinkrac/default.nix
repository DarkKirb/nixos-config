{
  nixos-config,
  lib,
  ...
}:
{
  networking.hostName = "thinkrac";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    "${nixos-config}/config/networkmanager.nix"
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
  specialisation.sway = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sway";
        isSway = true;
      }
    ];
  };
  specialisation.sway-nsfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "sway-sfw";
        isSway = true;
        isNSFW = lib.mkForce false;
      }
    ];
  };
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "gccarch-skylake"
    "ca-derivations"
  ];
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
}
