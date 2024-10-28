{
  system,
  riscv-overlay,
  ...
}:
if system == "riscv64-linux"
then {
  nixpkgs.overlays = [
    riscv-overlay.overlays.default
  ];
}
else {}
