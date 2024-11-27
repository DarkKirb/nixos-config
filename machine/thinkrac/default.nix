{
  nixos-config,
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
    #"${nixos-config}/config/graphical/plymouth.nix"
  ];
  system.stateVersion = "24.11";
  specialisation.nsfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "nsfw";
        isNSFW = true;
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
        nix.auto-update.specialisation = "sway-nsfw";
        isSway = true;
        isNSFW = true;
      }
    ];
  };
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "gccarch-skylake"
    "ca-derivations"
  ];
}
