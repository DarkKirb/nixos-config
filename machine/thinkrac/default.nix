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
  specialisation.nsfw = {
    configuration.imports = [
      {
        nix.auto-update.specialisation = "nsfw";
        isNSFW = true;
      }
    ];
  };
  specialisation.quiet-nsfw = {
    configuration.imports = [
      "${nixos-config}/config/graphical/plymouth.nix"
      {
        nix.auto-update.specialisation = "quiet-nsfw";
        isNSFW = true;
      }
    ];
  };
}
