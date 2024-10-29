{disko, ...}: {
  imports = [
    ./riscv.nix
    ./containers/autoconfig.nix
    ./nix/lix.nix
    ./environment/impermanence.nix
    ./secrets/sops.nix
    disko.nixosModules.default
  ];
}
