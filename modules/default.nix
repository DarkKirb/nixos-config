{disko, ...}: {
  imports = [
    ./riscv.nix
    ./containers/autoconfig.nix
    ./nix
    ./environment/impermanence.nix
    ./secrets/sops.nix
    disko.nixosModules.default
    ./hydra/build-server.nix
  ];
}
