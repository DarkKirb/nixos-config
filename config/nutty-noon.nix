{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  ...
}: {
  networking.hostName = "nutty-noon";
  networking.hostId = "e77e1829";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    ./services/tpm2.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./services/postgres.nix
    ./users/remote-build.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "k10temp"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux_xanmod_latest);

  fileSystems."/" = {
    device = "/dev/disk/by-partuuid/53773b73-fb8a-4de8-ac58-d9d8ff1be430";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/home/darkkirb/hdd" = {
    device = "/dev/disk/by-partuuid/d4c6a94f-2ae9-e446-9613-2596c564078c";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CA0B-E049";
    fsType = "vfat";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/" "/home/darkkirb/hdd"];
  };
  services.snapper.configs.main = {
    SUBVOLUME = "/";
    TIMELINE_LIMIT_HOURLY = "5";
    TIMELINE_LIMIT_DAILY = "7";
    TIMELINE_LIMIT_WEEKLY = "4";
    TIMELINE_LIMIT_MONTHLY = "12";
    TIMELINE_LIMIT_YEARLY = "0";
  };
  services.snapper.configs.hdd = {
    SUBVOLUME = "/home/darkkirb/hdd";
    TIMELINE_LIMIT_HOURLY = "5";
    TIMELINE_LIMIT_DAILY = "7";
    TIMELINE_LIMIT_WEEKLY = "4";
    TIMELINE_LIMIT_MONTHLY = "12";
    TIMELINE_LIMIT_YEARLY = "0";
  };
  services.beesd.filesystems.root = {
    spec = "/";
    hashTableSizeMB = 2048;
    verbosity = "crit";
    extraOptions = ["--loadavg-target" "5.0"];
  };
  services.beesd.filesystems.hdd = {
    spec = "/home/darkkirb/hdd";
    hashTableSizeMB = 2048;
    verbosity = "crit";
    extraOptions = ["--loadavg-target" "5.0"];
  };

  networking.interfaces.enp34s0.useDHCP = true;

  system.stateVersion = "21.11";

  services.xserver.videoDrivers = ["amdgpu"];

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
  
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-znver2"
    "gccarch-znver1"
    "gccarch-skylake"
    "ca-derivations"
  ];
  networking.firewall.allowedTCPPorts = [58913];

  environment.etc."pipewire/pipewire.conf.d/hi-res.conf".text = ''
    context.properties = {
      default.clock.rate = 384000
      default.clock.allowedRates = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ]
      default.clock.quantum = 8192
    }
  '';
  services.tailscale.useRoutingFeatures = "client";
  home-manager.users.darkkirb._module.args.withNSFW = lib.mkForce true;
  system.autoUpgrade.allowReboot = true;
  networking.extraHosts = "192.168.2.1 speedport.ip";
}
