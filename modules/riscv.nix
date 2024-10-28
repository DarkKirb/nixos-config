{
  system,
  riscv-overlay,
  ...
}: {
  nixpkgs.overlays =
    if system == "riscv64-linux"
    then [
      riscv-overlay.overlays.default
    ]
    else [];
}
