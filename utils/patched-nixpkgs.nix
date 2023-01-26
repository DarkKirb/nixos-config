{
  nixpkgs,
  patches,
  system,
}: let
  pkgs = import nixpkgs {
    inherit system;
  };
  nixpkgs-new = pkgs.applyPatches {
    name = "nixpkgs-patched";
    src = nixpkgs;
    inherit patches;
  };
in
  nixpkgs-new
