{ config, pkgs, modulesPath, lib, nixos-hardware, system, ... }: {
  networking.hostName = "thinkrac";
  networking.hostId = "2bfaea87";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    #./services/tpm2.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    nixos-hardware.nixosModules.common-cpu-intel-kaby-lake
    nixos-hardware.nixosModules.common-pc-ssd
  ];
  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "bcache" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "tank" ];


  boot.initrd.luks.devices = {
    disk = {
      device = "/dev/disk/by-uuid/2100a2e1-d874-4aaa-a89f-0b01665445b4";
      allowDiscards = true;
    };
  };

  fileSystems."/" = {
    device = "tank/nixos";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "tank/nixos/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc" = {
    device = "tank/nixos/etc";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var" = {
    device = "tank/nixos/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib" = {
    device = "tank/nixos/var/lib";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/log" = {
    device = "tank/nixos/var/log";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/spool" = {
    device = "tank/nixos/var/spool";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home" = {
    device = "tank/userdata/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/root" = {
    device = "tank/userdata/home/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home/darkkirb" = {
    device = "tank/userdata/home/darkkirb";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/build" = {
    device = "tank/build";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EE61-E55F";
    fsType = "vfat";
  };

  networking.interfaces.enp0s31f6.useDHCP = true;
  system.stateVersion = "21.11";
  networking.wireguard.interfaces."wg0".ips = [
    "fd0d:a262:1fa6:e621:f45a:db9f:eb7c:1a3f/64"
  ];
  networking.nameservers = [ "fd00:e621:e621:2::2" ];
  services.xserver.videoDrivers = [ "modesetting" ];
  nix.settings.cores = 4;

  # Disable kernel mitigations
  #
  # Rationale:
  # - device has a limited workload, consisting mostly of running trusted code and visiting trusted websites with an advertisement blocker
  # - device is battery powered (we want to spend more time in an idle state, as opposed to running user code or mitigating cpu bugs)
  # - device is also not involved in any sort of virtualization
  boot.kernelParams = [ "mitigations=off" ];
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
  users.users.darkkirb.extraGroups = [ "networkmanager" ];
  nix.settings.max-jobs = 4;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  nix.systemFeatures = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-skylake"
    "ca-derivations"
  ];
}
