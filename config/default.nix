{
  pkgs,
  nixos-config,
  config,
  lib,
  ...
}:
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
  systemd.tmpfiles.rules = [
    "d /var/lib/private 700 root root - -"
    "z /var/lib/private 700 root root - -"
  ];
  security.pam.services.su.forwardXAuth = lib.mkForce config.isGraphical;
}
