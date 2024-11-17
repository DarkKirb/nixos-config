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
    "${nixos-config}/config/graphical/plymouth.nix"
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
}
