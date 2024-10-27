{nixpkgs, ...}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
  ];
  networking.hostId = "8425e349";
}
