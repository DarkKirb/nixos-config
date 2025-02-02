# Cross compiled packages for when shit breaks
{
  nixpkgs,
  lix,
  self,
  lib,
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
    config.allowUnfree = true;
  };
  pkgs_x86_64_native = import nixpkgs {
    system = "x86_64-linux";
    overlays = [
      lix.overlays.default
      self.overlays.default
    ];
    config.allowUnfree = true;
  };
  pkgs_x86_64_2 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
  };
in
{
  nixpkgs.overlays = lib.mkAfter [
    (self: super: {
      inherit (pkgs_x86_64) lix palette-generator;
      inherit (pkgs_x86_64_2) nixos-option;
      inherit (pkgs_x86_64_native) palettes;
      gnupg = super.gnupg.override {
        withTpm2Tss = false;
      };
      gnupg24 = super.gnupg24.override {
        withTpm2Tss = false;
      };
      systemd = super.systemd.override {
        withTpm2Tss = false;
      };
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
