{ nixos-config, ... }:
{
  imports = [ "${nixos-config}/config/graphical/plymouth.nix" ];
}
