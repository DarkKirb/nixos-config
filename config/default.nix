{ pkgs, nixos-config, ... }:
{
  imports = [
    "${nixos-config}/modules"
    "${nixos-config}/services/tailscale.nix"
    "${nixos-config}/services/openssh.nix"
    "${nixos-config}/users"
    "${nixos-config}/programs"
    ./systemd-boot.nix
    ./i18n.nix
  ];
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
}
