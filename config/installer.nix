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
  boot.supportedFilesystems = ["zfs"];
  # Oldest system I have is skylake-based
  /*
   nixpkgs.localSystem = {
   gcc.arch = "skylake";
   gcc.tune = "skylake";
   system = "x86_64-linux";
   };
   */
}
