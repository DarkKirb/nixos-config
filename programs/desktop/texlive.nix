{ pkgs, ... }:
{
  home.packages = [
    pkgs.texlive.combined.scheme-full
  ];
}
