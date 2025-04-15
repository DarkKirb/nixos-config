{
  ...
}:
{
  networking.hostName = "thinkrac";
  imports = [
    ../../config
    ./disko.nix
    ./hardware.nix
    ../../config/networkmanager.nix
    ../../config/graphical.nix
    ../../config/graphical/plymouth.nix
  ];
  system.stateVersion = "24.11";
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "gccarch-skylake"
    "ca-derivations"
  ];
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
}
