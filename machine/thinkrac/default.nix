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
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "gccarch-skylake"
    "ca-derivations"
  ];
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  nixpkgs.config.allowUnfree = true;
}
