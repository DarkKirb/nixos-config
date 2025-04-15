{
  nixos-config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "pc-installer";
  imports = [
    ../../config
    ./disko.nix
    ./hardware.nix
    ../../config/networkmanager.nix
  ];
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  system.stateVersion = "24.11";
  system.isInstaller = true;
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-thinkrac-unattended" ''
      set -eux
      exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${../..}#thinkrac" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
    (pkgs.writeShellScriptBin "install-rainbow-resort-unattended" ''
      set -eux
      exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${../..}#rainbow-resort" --disk main "${nixos-config.nixosConfigurations.rainbow-resort.config.disko.devices.disk.main.device}"
    '')
  ];
}
