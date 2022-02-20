{ config, lib, options, pkgs, ... }:
with lib;
let
  vault = pkgs.callPackage ../../packages/minecraft/vault.nix { };
  cfg = config.services.minecraft.vault;
  opt = options.services.minecraft.vault;
in
{
  options.services.minecraft.vault.enable = mkOption {
    default = false;
    type = types.bool;
    description = "Enable Vault";
  };
  config = mkIf cfg.enable {
    services.minecraft.plugins = [{
      package = vault;
      startScript = pkgs.writeScript "dummy" "";
    }];
  };
}
