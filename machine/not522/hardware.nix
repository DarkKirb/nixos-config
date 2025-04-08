{
  nixos-hardware,
  lib,
  nixpkgs,
  nixos-config,
  ...
}:
{
  boot.kernelPatches = [
    {
      name = "fix-dumb-qa-issue";
      patch = ./fix-qa-issue.patch;
    }
  ];
  imports = [
    "${nixos-hardware}/starfive/visionfive/v2/default.nix"
  ];
  hardware.deviceTree.name = "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
  boot.initrd.kernelModules = [
    "clk-starfive-jh7110-aon"
    "clk-starfive-jh7110-stg"
    "phy-jh7110-pcie"
    "pcie-starfive"
    "nvme"
  ];
  nix.settings.system-features = [
    "gccarch-rv64gc_zba_zbb"
  ];
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.initrd.systemd.tpm2.enable = lib.mkForce false;
  systemd.tpm2.enable = lib.mkForce false;

  nixpkgs.overlays = [
    nixos-config.overlays.riscv64-linux
  ];
}
