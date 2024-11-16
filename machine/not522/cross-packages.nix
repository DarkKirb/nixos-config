# Cross compiled packages for when shit breaks
{
  nixpkgs,
  lix,
  ...
}:
let
  pkgs_x86_64 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
    overlays = [ lix.overlays.default ];
  };
  pkgs_x86_64_2 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgs_x86_64) lix;
      inherit (pkgs_x86_64_2) nixos-option;
    })
  ];
}
