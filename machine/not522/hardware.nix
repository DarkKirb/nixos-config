{
  pkgs,
  nixos-hardware,
  config,
  lib,
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
  boot.loader.systemd-boot.extraInstallCommands = ''
    set -euo pipefail
    ${lib.getExe' pkgs.coreutils "cp"} --no-preserve=mode -r ${config.hardware.deviceTree.package} ${config.boot.loader.efi.efiSysMountPoint}/
    if [[ -d ${config.boot.loader.efi.efiSysMountPoint}/loader/entries ]]; then
      for filename in ${config.boot.loader.efi.efiSysMountPoint}/loader/entries/nixos*-generation-[1-9]*.conf; do
        if ! ${lib.getExe pkgs.gnugrep} -q 'devicetree' $filename; then
          ${lib.getExe' pkgs.coreutils "echo"} "devicetree /dtbs/${config.hardware.deviceTree.name}" >> $filename
        fi
      done
    fi
  '';
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
}
