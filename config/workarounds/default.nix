{ nixpkgs-soundtouch, nixpkgs-tdesktop, system, pkgs, nixpkgs, ... }:
let
  rawPerlPackages = pkgs.callPackage "${nixpkgs}/pkgs/top-level/perl-packages.nix" {
    overrides = pkgs: { };
    buildPerl = pkgs.perl;
  };
  hydra = pkgs.callPackage "${nixpkgs}/pkgs/development/tools/misc/hydra/common.nix" {
    version = "2021-08-11";
    src = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "9bce425c3304173548d8e822029644bb51d35263";
      sha256 = "sha256-tGzwKNW/odtAYcazWA9bPVSmVXMGKfXsqCA1UYaaxmU=";
    };
    nix = (import nixpkgs-soundtouch { inherit system; }).nixVersions.unstable;
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
