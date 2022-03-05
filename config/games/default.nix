{ pkgs, ... }:
let
  wine-tkg = pkgs.nix-gaming.wine-tkg;
in
{
  home.packages = [
    wine-tkg
    pkgs.grapejuice
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
