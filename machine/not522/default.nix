{
  nixpkgs,
  ...
}:
{
  networking.hostName = "not522";
  imports = [
    ../../config
    ./disko.nix
    ./hardware.nix
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
  ];
  system.stateVersion = "24.11";
  nix.settings.system-features = [
    "native-riscv"
    "big-parallel"
    "ca-derivations"
  ];
}
