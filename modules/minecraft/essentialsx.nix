{ config, lib, options, pkgs, ... }:
with lib;
let
  essentialsx = pkgs.callPackage ../../packages/minecraft/essentialsx.nix { };
  cfg = config.services.minecraft.essentialsx;
  opt = options.services.minecraft.essentialsx;
in
{
  options.services.minecraft.essentialsx = {
    enable = mkOption {
      default = false;
      description = "Enable EssentialsX";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.minecraft = {
      vault.enable = config.services.minecraft.luckperms.enable;
    };
    services.minecraft.plugins = [{
      package = essentialsx.essentialsx;
      startScript = pkgs.writeScript "dummy" "";
    }];
  };
}
