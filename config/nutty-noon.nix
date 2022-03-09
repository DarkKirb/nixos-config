{ config, pkgs, modulesPath, lib, ... }: {
  networking.hostName = "nutty-noon";
  networking.hostId = "e77e1829";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    ./services/tpm2.nix
    ./services/hydra.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "k10temp" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "ssd" "hdd" ];

  boot.initrd.luks.devices = {
    ssd = {
      device = "/dev/disk/by-partuuid/53773b73-fb8a-4de8-ac58-d9d8ff1be430";
      allowDiscards = true;
    };
    hdd = {
      device = "/dev/disk/by-partuuid/d4c6a94f-2ae9-e446-9613-2596c564078c";
    };
  };

  fileSystems."/" =
    {
      device = "ssd/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    {
      device = "ssd/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/etc" =
    {
      device = "ssd/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    {
      device = "ssd/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib" =
    {
      device = "ssd/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/log" =
    {
      device = "ssd/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/spool" =
    {
      device = "ssd/nixos/var/spool";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    {
      device = "ssd/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root" =
    {
      device = "ssd/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/tank" =
    {
      device = "ssd/userdata/home/tank";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/darkkirb/hdd" =
    {
      device = "hdd/userdata/home/darkkirb/hdd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root/hdd" =
    {
      device = "hdd/userdata/home/root/hdd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/CA0B-E049";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/110ae65d-8ea1-214d-bd7b-a6f3e1b5dc3a";
      randomEncryption = true;
    }
  ];

  networking.interfaces.enp34s0.useDHCP = true;

  system.stateVersion = "21.11";

  networking.wireguard.interfaces."wg0".ips = [ "fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/64" ];
  networking.nameservers = [ "192.168.2.1" ];

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.etc."sysconfig/lm_sensors".text = ''
    # Generated by sensors-detect on Tue Aug  7 10:54:09 2018
    # This file is sourced by /etc/init.d/lm_sensors and defines the modules to
    # be loaded/unloaded.
    #
    # The format of this file is a shell script that simply defines variables:
    # HWMON_MODULES for hardware monitoring driver modules, and optionally
    # BUS_MODULES for any required bus driver module (for example for I2C or SPI).

    HWMON_MODULES="nct6775"
  '';

  nix.settings.cores = 16;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "wasm32-wasi"
  ];
  # Allow high-res audio on PC
  services.pipewire.config.pipewire."context.properties"."default.clock.rate" = 384000;
  services.pipewire.config.pipewire."context.properties"."default.clock.allowed-rates" = [
    44100
    48000
    88200
    96000
    176400
    192000
    352800
    384000
  ];
  nix.buildMachines = [
    {
      maxJobs = 16;
      speedFactor = 2;
      hostName = "localhost";
      systems = [
        "armv7l-linux"
        "aarch64-linux"
        "powerpc-linux"
        "powerpc64-linux"
        "powerpc64le-linux"
        "riscv32-linux"
        "riscv64-linux"
        "wasm32-wasi"
        "x86_64-linux"
        "i686-linux"
      ];
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver2" ];
    }
  ];
  hardware.enableRedistributableFirmware = true;
  nix.settings.substituters = lib.mkForce [
    "https://cache.nixos.org/"
  ];
}
