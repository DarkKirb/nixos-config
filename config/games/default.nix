{ pkgs, ... }:
let
  wine-tkg = pkgs.nix-gaming.wine-tkg;
in
{
  imports = [
    ./grapejuice.nix
  ];
  home.packages = [
    wine-tkg
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
