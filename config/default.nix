{
  pkgs,
  nixos-config,
  config,
  lib,
  ...
}:
{
  imports = [
    nixos-config.nixosModules.default
    ../services
    ../users
    ../programs
    ./systemd-boot.nix
    ./i18n.nix
    ./overlays
  ];
  system.standardConfig = true;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = false;
  systemd.tmpfiles.rules = [
    "d /var/lib/private 700 root root - -"
    "z /var/lib/private 700 root root - -"
  ];
  security.pam.services.su.forwardXAuth = lib.mkForce config.system.isGraphical;
}
