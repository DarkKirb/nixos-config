{
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  networking.wireguard.interfaces."wg0".ips = [
    "fd0d:a262:1fa6:e621:6ec2:1e4e:ce7f:d2af/64"
  ];
  boot.supportedFilesystems = lib.mkForce ["bcachefs" "vfat"];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing_bcachefs;
  networking.hostId = "8425e349";
  nix.settings.post-build-hook = lib.mkForce "true";
  nixpkgs.localSystem = {
    system = "x86_64-linux";
    gcc.arch = "skylake";
    gcc.tune = "skylake";
  };
}
