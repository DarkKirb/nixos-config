{ nixos-config, ... }:
{
  imports = [ "${nixos-config}/config/graphical.nix" ];
  system.wm = "sway";
}
