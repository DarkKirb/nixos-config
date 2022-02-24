{ config, lib, options, pkgs, ... }:
with lib;
let
  multiverse = pkgs.callPackage ../../packages/minecraft/multiverse.nix { };
  cfg = config.services.minecraft.multiverse;
  opt = options.services.minecraft.multiverse;
in
{
  options.services.minecraft.multiverse = {
    enable = mkOption {
      default = false;
      description = "Enable Multiverse";
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.minecraft.plugins = mkMerge [
      [{
        package = multiverse.core;
        startScript = pkgs.writeScript "dummy" "";
      }]
    ];
  };
}
