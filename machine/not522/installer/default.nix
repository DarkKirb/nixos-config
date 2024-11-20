{
  nixos-config,
  config,
  pkgs,
  nixpkgs,
  ...
}:
{
  networking.hostName = "not522-installer";
  imports = [
    "${nixos-config}/config"
    "${nixos-config}/machine/not522/hardware.nix"
    "${nixos-config}/machine/not522/cross-packages.nix"
    ./disko.nix
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
  ];

  system.stateVersion = config.system.nixos.version;

  #environment.etc."system/not522".source = "${nixos-config.nixosConfigurations.not522.config.system.build.toplevel}";
  #environment.etc."system/not522-disko".source = "${nixos-config.nixosConfigurations.not522.config.system.build.diskoScript}";

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-nixos-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#not522" --disk main "${nixos-config.nixosConfigurations.not522.config.disko.devices.disk.main.device}"
    '')
  ];
  isInstaller = true;
  nixpkgs.crossSystem = {
    config = "riscv64-unknown-linux-gnu";
    system = "riscv64-linux";
  };
}
