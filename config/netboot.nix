{
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/netboot/netboot-base.nix"
    ../modules/bcachefs.nix
  ];
  networking.wireguard.interfaces."wg0".ips = [
    "fd0d:a262:1fa6:e621:6ec2:1e4e:ce7f:d2af/64"
  ];
  boot.supportedFilesystems = lib.mkForce ["bcachefs" "vfat"];
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux-bcachefs);
  networking.hostId = "8425e349";
  nix.settings.post-build-hook = lib.mkForce "true";
}
