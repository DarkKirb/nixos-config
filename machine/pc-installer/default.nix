{
  config,
  nixos-config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "pc-installer";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./grub.nix
    ./hardware.nix
    "${nixos-config}/config/networkmanager.nix"
  ];
  system.stateVersion = config.system.nixos.version;
  isInstaller = true;
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-thinkrac-unattended" ''
      set -eux
      exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${nixos-config}#thinkrac" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
    (pkgs.writeShellScriptBin "install-rainbow-resort-unattended" ''
      set -eux
      exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${nixos-config}#rainbow-resort" --disk main "${nixos-config.nixosConfigurations.rainbow-resort.config.disko.devices.disk.main.device}"
    '')
  ];
}
