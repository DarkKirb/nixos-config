{ config, lib, options, pkgs, ... }:
with lib;
let
  luckperms = pkgs.callPackage ../../packages/minecraft/luckperms.nix { };
  cfg = config.services.minecraft.luckperms;
  opt = options.services.minecraft.luckperms;
in
{
  options.services.minecraft.luckperms = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable LuckPerms";
    };
  };
  config = mkIf cfg.enable {
    services.minecraft.plugins = [ luckperms ];
  };
}
