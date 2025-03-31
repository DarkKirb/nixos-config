{ lib, ... }:
{
  networking.hostName = "pinebook";
  imports = [
    ../../config
    ./disko.nix
    ./hardware.nix
    ../../config/graphical.nix
    #../../config/graphical/plymouth.nix
    ../../config/networkmanager.nix
  ];
  system.stateVersion = "24.11";
  services.postgresql.enable = lib.mkForce false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];
}
