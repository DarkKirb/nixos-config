{
  config,
  modulesPath,
  lib,
  nixos-hardware,
  nixpkgs,
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
    ./services/syncthing.nix
    ../modules/tc-cake.nix
    ./services/cups.nix
    ./services/iscsi.nix
    ./services/samba.nix
    ./services/docker.nix
    ./users/remote-build.nix
    ./services/nfs.nix
    ./services/tempo.nix
    ./services/loki.nix
    ./services/prometheus.nix
    ./services/yiff-stash.nix
    ./services/reverse-proxy.nix
    ./services/jellyfin.nix
    ../new-infra/devices/nas.nix
    ./services/mautrix-discord.nix
    ./services/mautrix-telegram.nix
    ./services/mautrix-whatsapp.nix
    ./services/mautrix-signal.nix
    ./services/synapse.nix
    ./services/heisenbridge.nix
    ./services/matrix-sliding-sync.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "bcache"];
  boot.initrd.kernelModules = ["igb"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  fileSystems."/" = {
    device = "tank/system/root";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "tank/system/etc";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "tank/system/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "tank/data/var";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  services.sanoid = {
    enable = true;
    datasets."tank/data" = {
      yearly = 1;
      recursive = true;
      monthly = 12;
      hourly = 24;
      daily = 30;
      autosnap = true;
      autoprune = true;
    };
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
  nix.settings.substituters = lib.mkForce [
    "https://attic.chir.rs/chir-rs/"
    "https://cache.nixos.org/"
    "https://beam.attic.rs/riscv"
    "https://cache.ztier.in"
  ];
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
