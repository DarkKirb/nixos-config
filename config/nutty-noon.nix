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
    ./secureboot.nix
    nixos-hardware.nixosModules.common-cpu-amd
    #nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./services/postgres.nix
    ./services/docker.nix
    ./services/drone-runner-docker.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "k10temp"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];
  boot.kernelPackages = pkgs.zfsUnstable.latestCompatibleLinuxPackages;
  boot.zfs.enableUnstable = true;

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = ["ssd" "hdd"];

  boot.initrd.luks.devices = {
    ssd = {
      device = "/dev/disk/by-partuuid/53773b73-fb8a-4de8-ac58-d9d8ff1be430";
      allowDiscards = true;
    };
    hdd = {
      device = "/dev/disk/by-partuuid/d4c6a94f-2ae9-e446-9613-2596c564078c";
    };
  };

  fileSystems."/" = {
    device = "ssd/nixos";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/nix" = {
    device = "ssd/nixos/nix";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/etc" = {
    device = "ssd/nixos/etc";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var" = {
    device = "ssd/nixos/var";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var/lib" = {
    device = "ssd/nixos/var/lib";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var/log" = {
    device = "ssd/nixos/var/log";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var/spool" = {
    device = "ssd/nixos/var/spool";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home" = {
    device = "ssd/userdata/home";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/root" = {
    device = "ssd/userdata/home/root";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/darkkirb" = {
    device = "ssd/userdata/home/darkkirb";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/build" = {
    device = "hdd/build";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/boot" = {
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

  networking.wireguard.interfaces."wg0".ips = ["fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/64"];

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
    "aarch64-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "wasm32-wasi"
  ];
  nix.buildMachines = lib.mkForce [
    #{
    #  hostName = "build-nas";
    #  systems = [ "x86_64-linux" ];
    #  maxJobs = 12;
    #  speedFactor = 1;
    #  supportedFeatures = [ "gccarch-znver1" "ca-derivations" ];
    #}
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
      supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver2" "gccarch-znver1" "gccarch-skylake" "ca-derivations"];
    }
  ];
  hardware.enableRedistributableFirmware = true;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  networking.wireguard.interfaces.wg0.peers = [
    # nas
    {
      publicKey = "RuQImASPojufJMoJ+zZ4FceC+mMN5vhxNR+i+m7g9Bc=";
      allowedIPs = [
        "fd0d:a262:1fa6:e621:bc9b:6a33:86e4:873b/128"
      ];
      endpoint = "192.168.2.1:51820";
    }
  ];
  # Build server stuff

  users.users.darkkirb.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpO0Lh7eOE/EBttb/XWZ6ISiJ0RkmBYfruq3U6linEz root@nixos-8gb-fsn1-1"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKB8oH1XbuGrKn/SeguXz96sw4AjJQQvZyAdpptotzOr root@thinkrac"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN/rVZJuwiO44LwOqimpH4zyGehYUMF2ZhYFXUCkupP hydra-queue-runner@nas"
  ];
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
  virtualisation.docker.daemon.settings = {
    storage-opts = [
      "zfs.fsname=hdd/docker"
    ];
  };
}
