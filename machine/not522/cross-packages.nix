# Cross compiled packages for when shit breaks
{
  nixpkgs,
  lix,
  ...
}: let
  pkgs_x86_64 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
    overlays = [lix.overlays.default];
  };
in {
  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgs_x86_64) lix nixos-option;
    })
  ];
}
