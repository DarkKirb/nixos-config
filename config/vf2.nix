{
  lib,
  nix-packages,
  config,
  pkgs,
  ...
}: {
  networking.hostName = "vf2";
  networking.hostId = "ad325df9";
  imports = [
    ./services/caddy
    ./services/acme.nix
    ./services/fail2ban.nix
  ];
  environment.systemPackages = with pkgs; [
    pinentry-curses
  ];
  programs.gnupg.agent.pinentryFlavor = "curses";

  nixpkgs.overlays = [
    (import ../overlays/riscv.nix)
  ];

  boot = {
    supportedFilesystems = lib.mkForce ["vfat" "ext4"];
    kernelPackages = nix-packages.packages.riscv64-linux.vf2KernelPackages;
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200"
      "earlycon=sbi"
      "boot.shell_on_fail"
    ];
    blacklistedKernelModules = [
      # Last thing to log before crash...
      "axp15060-regulator"
      # Also sus
      "at24"
      # Also also sus
      "jh7110-vin"
      # Maybe??
      "starfive-jh7110-regulator"

      # This one stopped the crashing
      "starfivecamss"
    ];

    initrd.includeDefaultModules = false;
    initrd.availableKernelModules = [
      "dw_mmc-pltfm"
      "dw_mmc-starfive"
      "dwmac-starfive-plat"
      "spi-dw-mmio"
      "mmc_block"
      "nvme"
      "sdhci" #?
      "sdhci-pci" #?
      "sdhci-of-dwcmshc"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = ["nofail" "noauto"];
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
  hardware.deviceTree.name = "starfive/jh7110-visionfive-v2.dtb";
  system.stateVersion = "22.11";
}
