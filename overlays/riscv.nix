args: self: prev: let
  pkgsX86 = import args.nixpkgs {
    system = "x86_64-linux";
    crossSystem = "riscv64-linux";
    overlays = [args.self.overlays.riscv64-linux];
    config.allowUnfree = true;
  };
in {
  inherit (pkgsX86) pandoc gccgo gfortran;
}
