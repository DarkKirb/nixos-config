{
  config,
  nixos-config,
  pkgs,
  pureInputs,
  lib,
  ...
}:
let
  dependencies = [
    nixos-config.nixosConfigurations.rainbow-resort.config.system.build.toplevel
    nixos-config.nixosConfigurations.rainbow-resort.config.system.build.diskoScript
    nixos-config.nixosConfigurations.rainbow-resort.config.system.build.diskoScript.drvPath
    nixos-config.nixosConfigurations.rainbow-resort.pkgs.stdenv.drvPath
    (nixos-config.nixosConfigurations.rainbow-resort.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
    nixos-config.nixosConfigurations.thinkrac.config.system.build.toplevel
    nixos-config.nixosConfigurations.thinkrac.config.system.build.diskoScript
    nixos-config.nixosConfigurations.thinkrac.config.system.build.diskoScript.drvPath
    nixos-config.nixosConfigurations.thinkrac.pkgs.stdenv.drvPath
    (nixos-config.nixosConfigurations.thinkrac.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
    nixos-config.nixosConfigurations.nas.config.system.build.toplevel
    nixos-config.nixosConfigurations.nas.pkgs.stdenv.drvPath
    (nixos-config.nixosConfigurations.nas.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
  ] ++ map (i: i.outPath) (builtins.filter builtins.isAttrs (builtins.attrValues pureInputs));

  closureInfo = pkgs.closureInfo { rootPaths = dependencies; };
in
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
  environment.etc."install-closure".source = "${closureInfo}/store-paths";
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
