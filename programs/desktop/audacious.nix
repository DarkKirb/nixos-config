{ pkgs, ... }:
{
  home.packages = with pkgs; [ audacious ];
  home.persistence.default.directories = [
    ".config/audacious"
  ];
}
