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
    enableChat = mkOption {
      default = true;
      description = "Enable EssentialsX Chat";
      type = types.bool;
    };
    enableSpawn = mkOption {
      default = true;
      description = "Enable EssentialsX Spawn";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable
    {
      services.minecraft = {
        vault.enable = config.services.minecraft.luckperms.enable;
      };
      services.minecraft.plugins = lib.mkMerge [
        [{
          package = essentialsx.essentialsx;
          startScript = pkgs.writeScript "dummy" "";
        }]
        (
          mkIf cfg.enableChat
            [{
              package = essentialsx.essentialsx-chat;
              startScript = pkgs.writeScript "dummy" "";
            }]
        )
        (
          mkIf cfg.enableSpawn
            [{
              package = essentialsx.essentialsx-spawn;
              startScript = pkgs.writeScript "dummy" "";
            }]
        )
      ];
    };
}
