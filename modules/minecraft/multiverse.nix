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
    netherportals = mkOption {
      default = false;
      description = "Enable Nether portals";
      type = types.bool;
    };
    signportals = mkOption {
      default = false;
      description = "Enable sign portals";
      type = types.bool;
    };
    inventories = mkOption {
      default = false;
      description = "Enable inventories";
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.minecraft.plugins = mkMerge [
      [{
        package = multiverse.core;
        startScript = pkgs.writeScript "dummy" "";
      }]
      (mkIf cfg.netherportals
        [{
          package = multiverse.nether-portals;
          startScript = pkgs.writeScript "dummy" "";
        }])
      (mkIf cfg.signportals
        [{
          package = multiverse.sign-portals;
          startScript = pkgs.writeScript "dummy" "";
        }])
      (mkIf cfg.inventories
        [{
          package = multiverse.inventories;
          startScript = pkgs.writeScript "dummy" "";
        }])
    ];
  };
}
