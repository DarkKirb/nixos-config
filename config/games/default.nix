{ system, ... } @ args: { pkgs, ... }:
{
  imports = [
    (import ./grapejuice.nix args)
  ];
  home.packages = [
    pkgs.winePackages.staging
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
