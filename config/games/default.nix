{ system, nix-gaming, ... } @ args: { pkgs, ... }:
let
  wine-tkg = nix-gaming.outputs.packages.${system}.wine-tkg;
in
{
  imports = [
    (import ./grapejuice.nix args)
  ];
  home.packages = [
    wine-tkg
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
