{
  nixos-config,
  nixos-hardware,
  config,
  pureInputs,
  pkgs,
  lib,
  nixpkgs,
  ...
}: let
  dependencies =
    [
      nixos-config.nixosConfigurations.not522.config.system.build.toplevel
      nixos-config.nixosConfigurations.not522.config.system.build.diskoScript
      nixos-config.nixosConfigurations.not522.config.system.build.diskoScript.drvPath
      nixos-config.nixosConfigurations.not522.pkgs.stdenv.drvPath
      (nixos-config.nixosConfigurations.not522.pkgs.closureInfo {rootPaths = [];}).drvPath
    ]
    ++ map (i: i.outPath) (builtins.filter builtins.isAttrs (builtins.attrValues pureInputs));

  closureInfo = pkgs.closureInfo {rootPaths = dependencies;};
in {
  networking.hostName = "not522-installer";
  imports = [
    "${nixos-config}/config"
    "${nixos-config}/machine/not522/hardware.nix"
    "${nixos-config}/machine/not522/cross-packages.nix"
    ./disko.nix
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
  ];

  system.stateVersion = config.system.nixos.version;

  environment.etc."install-closure".source = "${closureInfo}/store-paths";

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-nixos-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#not522" --disk main "${nixos-config.nixosConfigurations.not522.config.disko.devices.disk.main.device}"
    '')
  ];
}
