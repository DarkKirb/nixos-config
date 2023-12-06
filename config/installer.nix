{nixpkgs, ...}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  networking.hostId = "8425e349";
}
