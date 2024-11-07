{
  disko,
  home-manager,
  lib,
  nur,
  ...
}:
with lib; {
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
}
