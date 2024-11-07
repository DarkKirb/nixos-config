{
  config,
  nixos-config,
  lib,
  ...
}: let
  dependencies =
    [
      nixos-config.nixosConfigurations.thinkrac.config.system.build.toplevel
      nixos-config.nixosConfigurations.thinkrac.config.system.build.diskoScript
      nixos-config.nixosConfigurations.thinkrac.config.system.build.diskoScript.drvPath
      nixos-config.nixosConfigurations.thinkrac.pkgs.stdenv.drvPath
      (nixos-config.nixosConfigurations.thinkrac.pkgs.closureInfo {rootPaths = [];}).drvPath
    ]
    ++ map (i: i.outPath) (builtins.filter builtins.isAttrs (builtins.attrValues pureInputs));

  closureInfo = pkgs.closureInfo {rootPaths = dependencies;};
in {
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
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-thinkrac-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#thinkrac" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
  ];
}
