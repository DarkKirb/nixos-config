{
  config,
  modulesPath,
  lib,
  nixos-hardware,
  nixpkgs,
  nix-packages,
  ...
} @ args: {
  networking.hostName = "nas";
  networking.hostId = "70af00ed";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./services/tpm2.nix
    ./server.nix
    ./services/hydra.nix
    ./services/backup.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./services/hostapd.nix
    ./services/router.nix
    ./services/syncthing.nix
    ../modules/tc-cake.nix
    ./services/cups.nix
    ./services/iscsi.nix
    ./services/samba.nix
    ./services/woodpecker.nix
    ./services/woodpecker-agent.nix
    ./services/docker.nix
    ./users/remote-build.nix
    ./services/kubo-local.nix
    ./services/nfs.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "bcache"];
  boot.initrd.kernelModules = ["igb"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/"];
  };
  services.snapper.configs.main = {
    SUBVOLUME = "/";
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

  boot.supportedFilesystems = lib.mkForce ["btrfs" "vfat"];

  fileSystems."/" = {
    device = "/dev/bcache0";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  networking.interfaces.br0 = {
    ipv4 = {
      addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 24;
        }
      ];
    };
  };
  networking.bridges = {
    br0.interfaces = ["enp9s0" "wlp7s0"];
  };
  networking.wireguard.interfaces."wg0".ips = ["fd0d:a262:1fa6:e621:bc9b:6a33:86e4:873b/64"];
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
  ];
  hardware.enableRedistributableFirmware = true;
  nix.settings.substituters = lib.mkForce [
    "https://attic.chir.rs/chir-rs/"
    "https://cache.nixos.org/"
    "https://beam.attic.rs/riscv"
    "https://cache.ztier.in"
  ];
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  networking.wireguard.interfaces.wg0.peers = [
    # nutty-noon
    {
      publicKey = "YYQmSJwipRkZJUsPV5DxhfyRBMdj/O1XzN+cGYtUi1s=";
      allowedIPs = [
        "fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/128"
      ];
    }
  ];

  system.stateVersion = "22.05";
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = false;
    inherit args;
  };

  networking.tc_cake = {
    enp2s0f0u4 = {
      disableOffload = true;
      shapeEgress = {
        bandwidth = "4mbit";
        extraArgs = "docsis nat ack-filter";
      };
      shapeIngress = {
        bandwidth = "33mbit";
        ifb = "ifb4enp2s0f0u4";
      };
    };
  };
  services.postgresql.settings = {
    max_connections = 200;
    shared_buffers = "4GB";
    effective_cache_size = "12GB";
    maintenance_work_mem = "1GB";
    checkpoint_completion_target = 0.9;
    wal_buffers = "16MB";
    default_statistics_target = 100;
    random_page_cost = 1.1;
    effective_io_concurrency = 200;
    work_mem = "5242kB";
    min_wal_size = "1GB";
    max_wal_size = "4GB";
    max_worker_processes = 12;
    max_parallel_workers_per_gather = 4;
    max_parallel_workers = 12;
    max_parallel_maintenance_workers = 4;
  };
  services.tailscale.useRoutingFeatures = "both";
  hardware.sane.brscan4.enable = true;
  services.kubo.settings.Addresses.API = lib.mkForce [
    "/ip4/0.0.0.0/tcp/5001"
    "/ip6/::/tcp/5001"
  ]; # Only exposed over the tailed scale

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
    {
      device = "/dev/sda3";
    }
    {
      device = "/dev/sdb3";
    }
    {
      device = "/dev/sdc3";
    }
  ];
}
