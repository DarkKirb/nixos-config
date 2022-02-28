{ nixpkgs-soundtouch, nixpkgs-tdesktop, system, pkgs, nixpkgs, ... }:
let
  rawPerlPackages = pkgs.callPackage "${nixpkgs}/pkgs/top-level/perl-packages.nix" {
    overrides = pkgs: { };
    buildPerl = pkgs.perl;
  };
  hydra = pkgs.callPackage "${nixpkgs}/pkgs/development/tools/misc/hydra/common.nix" {
    version = "2022-02-22";
    src = pkgs.fetchFromGitHub {
      owner = "nixos";
      repo = "hydra";
      rev = "a2546121f0c737b9fa5e6d311561ce57e7d0318a";
      sha256 = "092akmayvfwnqk17kl6jlzn5adi574xib9alw0w35rmavxp701zz";
    };
    nix = pkgs.nixVersions.unstable;
    tests = {
      basic = pkgs.nixosTests.hydra.hydra-unstable;
    };
  };
in
{
  nixpkgs.overlays = [
    (self: prev: {
      coreutils = prev.coreutils.overrideAttrs (old: {
        checkPhase = "true";
      });
      soundtouch = nixpkgs-soundtouch.legacyPackages.${system}.soundtouch;
      tdesktop = nixpkgs-tdesktop.legacyPackages.${system}.tdesktop;
      hydra-unstable = hydra.overrideAttrs (old: {
        patches = [
          ../../extra/hydra.patch
        ];
      });
    })
  ];
}
