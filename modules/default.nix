{
  disko,
  home-manager,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./nix
    ./environment/impermanence.nix
    ./secrets/sops.nix
    disko.nixosModules.default
    ./hydra/build-server.nix
    "${home-manager}/nixos"
  ];
  options.isGraphical = mkEnableOption "Whether or not this configuration is a graphical install";
  options.isInstaller = mkEnableOption "Whether or not this configuration is an installer and has no access to secrets";
  options.isNSFW = mkEnableOption "Whether or not this configuration is NSFW";
  options.isIntelGPU = mkEnableOption "Whether or not this configuration uses an Intel GPU";
  options.isSway = mkEnableOption "Whether to use sway or kde";
  config.isNSFW = lib.mkDefault true;
}
