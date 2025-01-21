{ pkgs, ... }:
{
  home.packages = [
    pkgs.picard
    pkgs.rsgain
  ];
}
