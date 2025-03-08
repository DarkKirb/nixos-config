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
    "dw_mmc-starfive"
    "motorcomm"
    "dwmac-starfive"
    "cdns3-starfive"
    "jh7110-trng"
    "phy-jh7110-usb"
    "clk-starfive-jh7110-aon"
    "clk-starfive-jh7110-stg"
    "clk-starfive-jh7110-vout"
    "clk-starfive-jh7110-isp"
    "clk-starfive-jh7100-audio"
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
  nixpkgs = {
    buildPlatform.config = "x86_64-linux";
    hostPlatform.config = "riscv64-linux";
    pkgs = lib.mkForce (
      import nixpkgs {
        system = "x86_64-linux";
        crossSystem = "riscv64-linux";
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      }
    );
  };

  nixpkgs.overlays = [
    nixos-config.overlays.riscv64-linux
  ];
}
