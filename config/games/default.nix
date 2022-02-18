{ pkgs, ... }:
let
  wine-tkg = pkgs.nix-gaming.wine-tkg;
in
{
  nixpkgs.overlays = [
    (curr: prev: {
      factorio = prev.factorio.override
        {
          version = "1.1.53";
        };
    })
  ];
  home.packages = [
    wine-tkg
    pkgs.grapejuice
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
