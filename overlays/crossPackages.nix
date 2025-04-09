inputs: _: _:
let
  pkgs_x86_64 = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [ inputs.self.overlays.default ];
    config.allowUnfree = true;
  };
  cross_pkgs_x86_64 = import inputs.nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
    overlays = [ inputs.self.overlays.default ];
    config.allowUnfree = true;
  };
in
{
  inherit (pkgs_x86_64) palettes;
  inherit (cross_pkgs_x86_64) pandoc;
}
