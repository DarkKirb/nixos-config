{ riscv-overlay }:
{
  nixpkgs.overlays = [
    riscv-overlay.overlays.default
  ];
  environment.etc."nix/inputs/nixpkgs-overlays/riscv-overlay.nix".text = "import ${riscv-overlay}/overlay.nix";
}
