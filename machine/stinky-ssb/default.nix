{ lib, nixos-config, ... }:
{
  networking.hostName = "stinky-ssb";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    "${nixos-config}/config/graphical.nix"
    #"${nixos-config}/config/graphical/plymouth.nix"
    "${nixos-config}/config/networkmanager.nix"
  ];
  system.stateVersion = "24.11";
  home-manager.users.darkkirb.imports = [ ./home-manager.nix ];
  services.postgresql.enable = lib.mkForce false;
  nixpkgs.config.allowUnfree = true;
}
