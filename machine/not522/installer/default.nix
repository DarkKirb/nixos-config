{
  pkgs,
  nixpkgs,
  nixos-config,
  lib,
  ...
}:
{
  networking.hostName = "not522-installer";
  imports = [
    ../../../config
    ../hardware.nix
    ./disko.nix
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
  ];

  system.stateVersion = "24.11";

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-nixos-unattended" ''
      set -eux
      exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${../../..}#not522" --disk main "${nixos-config.nixosConfigurations.not522.config.disko.devices.disk.main.device}"
    '')
  ];
  system.isInstaller = true;
}
