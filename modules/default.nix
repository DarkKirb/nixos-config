{
  disko,
  home-manager,
  lib,
  inTester,
  self,
  rust-overlay,
  ...
}:
with lib;
{
  imports = [
    ./riscv.nix
    ./containers/autoconfig.nix
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

  config =
    if !inTester then
      {
        nixpkgs.overlays = [
          self.overlays.default
          (import rust-overlay)
        ];
      }
    else
      { };
}
