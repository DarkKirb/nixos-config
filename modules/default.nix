{...}: {
  imports = [
    ./riscv.nix
    ./containers/autoconfig.nix
    ./lix.nix
    ./impermanence.nix
  ];
}
