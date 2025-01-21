{ pkgs, ... }:
{
  imports = [ ./rust ];
  home.packages = with pkgs; [
    (python3.withPackages (_: [ ]))
  ];
}
