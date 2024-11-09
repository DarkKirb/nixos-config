{
  config,
  nixos-config,
  lib,
  pkgs,
  pureInputs,
  ...
}:
let
  getDeps = name: [
    nixos-config.nixosConfigurations.${name}.config.system.build.toplevel
    nixos-config.nixosConfigurations.${name}.config.system.build.diskoScript
    nixos-config.nixosConfigurations.${name}.config.system.build.diskoScript.drvPath
    nixos-config.nixosConfigurations.${name}.pkgs.stdenv.drvPath
    (nixos-config.nixosConfigurations.${name}.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
  ];
  dependencies =
    (getDeps "rainbow-resort")
    ++ (getDeps "thinkrac")
    ++ map (i: i.outPath) (builtins.filter builtins.isAttrs (builtins.attrValues pureInputs));

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
  specialisation.graphical = {
    configuration.imports = [
      ./graphical.nix
      "${nixos-config}/config/graphical/plymouth.nix"
      {
        nix.auto-update.specialisation = "graphical";
      }
    ];
  };
  specialisation.graphical-verbose = {
    configuration.imports = [
      ./graphical.nix
      {
        nix.auto-update.specialisation = "graphical-verbose";
      }
    ];
  };
  isInstaller = true;
  environment.etc."install-closure".source = "${closureInfo}/store-paths";
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-thinkrac-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#thinkrac" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
    (pkgs.writeShellScriptBin "install-rainbow-resort-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#rainbow-resort" --disk main "${nixos-config.nixosConfigurations.rainbow-resort.config.disko.devices.disk.main.device}"
    '')
  ];
}
