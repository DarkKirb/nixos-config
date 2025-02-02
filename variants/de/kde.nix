{ nixos-config, ... }:
{
  imports = [ "${nixos-config}/config/graphical.nix" ];
}
