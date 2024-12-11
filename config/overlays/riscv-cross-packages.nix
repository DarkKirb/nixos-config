# Cross compiled packages for when shit breaks
{
  nixpkgs,
  lix,
  self,
  ...
}:
let
  pkgs_x86_64 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
    overlays = [
      lix.overlays.default
      self.overlays.default
    ];
  };
  pkgs_x86_64_2 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgs_x86_64) lix palette-generator;
      inherit (pkgs_x86_64_2) nixos-option;
    })
  ];
  environment.etc."nix/inputs/nixpkgs-overlays/riscv-cross-packages.nix".text = ''
    self: _: let pkgs_x86_64 = import <nixpkgs> {
      system = "x86_64-linux";
      crossSystem.system = "riscv64-linux";
      overlays = [self.inputs.lix.overlays.default self.inputs.nixos-config.overlays.default ];
    }
    pkgs_x86_64_2 = import <nixpkgs> {
      system = "x86_64-linux";
      crossSystem.system = "riscv64-linux";
      overlays = [];
    }; in {
      inherit (pkgs_x86_64) lix palette-generator;
      inherit (pkgs_x86_64_2) nixos-option;
    }
  '';
}
