{
  modulesPath,
  nixos-hardware,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "thinkrac";
  networking.hostId = "2bfaea87";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    ./services/tpm2.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    #nixos-hardware.nixosModules.common-cpu-intel-kaby-lake
    nixos-hardware.nixosModules.common-pc-ssd
    ./services/postgres.nix
  ];
  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "bcache"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux_xanmod_latest);

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/"];
  };
  services.snapper.configs.main = {
    SUBVOLUME = "/";
    TIMELINE_LIMIT_HOURLY = 5;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 4;
    TIMELINE_LIMIT_MONTHLY = 12;
    TIMELINE_LIMIT_YEARLY = 0;
  };
  services.beesd.filesystems.root = {
    spec = "/";
    hashTableSizeMB = 2048;
    verbosity = "crit";
    extraOptions = ["--loadavg-target" "5.0"];
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
    }
  ];

  networking.interfaces.enp0s31f6.useDHCP = true;
  system.stateVersion = "23.11";
  services.xserver.videoDrivers = ["modesetting"];
  nix.settings.cores = 4;

  # use the lowest frequency possible, to save power
  powerManagement.cpuFreqGovernor = "powersave";
  # lm_sensors who cares
  environment.etc."sysconfig/lm_sensors".text = ''
    # Generated by sensors-detect on Tue Aug  7 10:54:09 2018
    # This file is sourced by /etc/init.d/lm_sensors and defines the modules to
    # be loaded/unloaded.
    #
    # The format of this file is a shell script that simply defines variables:
    # HWMON_MODULES for hardware monitoring driver modules, and optionally
    # BUS_MODULES for any required bus driver module (for example for I2C or SPI).

    HWMON_MODULES="coretemp"
  '';
  services.thermald.enable = true;
  boot.extraModprobeConfig = ''
    # enable power savings mode of snd_hda_intel
    options snd-hda-intel power_save=1 power_save_controller=y
    # enable power savings mode of igpu, enable framebuffer compression, downclock the LVDS connection
    options i915 i915_enable_rc6=7 i915_enable_fbc=1 lvds_downclock=1
    # automatically suspend USB devices
    options usbcore autosuspend=2
    # Fan control for thinkpads
    options thinkpad_acpi fan_control=1
    options zfs zfs_arc_max=4294967296
  '';
  boot.kernel.sysctl = {
    # Probably unnecessary
    "kernel.nmi_watchdog" = "0";
    "vm.laptop_mode" = "5";
    # The kernel flusher threads will periodically wake up and write `old' data out to disk.  This
    # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
    "vm.dirty_writeback_centisecs" = "1500";
  };
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
  nix.settings.max-jobs = 4;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-skylake"
    "ca-derivations"
  ];
  services.joycond.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  system.autoUpgrade.allowReboot = true;
  services.prometheus.exporters.node.enabledCollectors = ["wifi"];
}
