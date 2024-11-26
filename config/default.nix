{ pkgs, nixos-config, ... }:
{
  imports = [
    "${nixos-config}/modules"
    "${nixos-config}/services"
    "${nixos-config}/users"
    "${nixos-config}/programs"
    ./systemd-boot.nix
    ./i18n.nix
    ./overlays
  ];
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = false;
}
