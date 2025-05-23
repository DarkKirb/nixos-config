{
  modulesPath,
  nixos-hardware,
  config,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "bcache"
  ];
  boot.initrd.kernelModules = [ "igb" ];
  boot.kernelModules = [ "kvm-amd" ];
  hardware.nvidia.open = false;
  fileSystems."/" = {
    device = "/dev/bcache0";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/bcache0";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/bcache0";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  environment.etc."sysconfig/lm_sensors".text = ''
    # Generated by sensors-detect on Sun Apr 24 08:31:51 2022
    # This file is sourced by /etc/init.d/lm_sensors and defines the modules to
    # be loaded/unloaded.
    #
    # The format of this file is a shell script that simply defines variables:
    # HWMON_MODULES for hardware monitoring driver modules, and optionally
    # BUS_MODULES for any required bus driver module (for example for I2C or SPI).

    HWMON_MODULES="it87"
  '';
  nix.settings.cores = 12;
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-znver1"
    "gccarch-skylake"
    "ca-derivations"
  ];
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "wasm32-wasi"
    "riscv32-linux"
    "riscv64-linux"
  ];
  hardware.enableRedistributableFirmware = true;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  system.stateVersion = "22.05";

  /*
    swapDevices = [
      {
        device = "/dev/sda2";
      }
      {
        device = "/dev/sdb2";
      }
      {
        device = "/dev/sdc2";
      }
    ];
  */
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = lib.mkForce false;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.restic.backups.sysbackup = {
    paths = [ "/media" ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly 10"
    ];
  };
  nix.settings.auto-optimise-store = lib.mkForce false;
}
