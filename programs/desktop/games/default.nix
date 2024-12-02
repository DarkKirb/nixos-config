{ pkgs, ... }:
{
  imports = [
    ./ff11
    ./ff14
  ];
  home.packages = with pkgs; [
    factorio
    wine-tkg
  ];
}
