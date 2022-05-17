{ config, pkgs, modulesPath, lib, nixos-hardware, ... } @ args: {
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
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc-hdd
    ./services/hostapd.nix
    ./services/mastodon.nix
    ./services/rspamd.nix
    ./services/synapse.nix
    ./services/mautrix-telegram.nix
    ./services/mautrix-whatsapp.nix
    ./services/mautrix-signal.nix
    ./services/router.nix
    ./services/syncthing.nix
    ../modules/tc-cake.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "igb" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "tank" ];

  boot.initrd.luks.devices = {
    disk0.device = "/dev/disk/by-partuuid/b122f4e7-9edf-402e-87a9-b709741fe8c9";
    disk1.device = "/dev/disk/by-partuuid/6e080c43-35fc-4c7c-a749-112d5b618a64";
    disk2.device = "/dev/disk/by-partuuid/13f012a4-b9a9-4144-8888-cbb637657f69";
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

  fileSystems."/var/lib/syncthing" = {
    device = "tank/nixos/var/lib/syncthing";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/syncthing/.wine" = {
    device = "tank/nixos/var/lib/syncthing/.wine";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/lennyface" = {
    device = "tank/nixos/var/lib/syncthing/lennyface";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Music-flac" = {
    device = "tank/nixos/var/lib/syncthing/Music-flac";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Studium" = {
    device = "tank/nixos/var/lib/syncthing/Studium";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Pictures" = {
    device = "tank/nixos/var/lib/syncthing/Pictures";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Data" = {
    device = "tank/nixos/var/lib/syncthing/Data";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/CarolineFlac" = {
    device = "tank/nixos/var/lib/syncthing/CarolineFlac";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Camera" = {
    device = "tank/nixos/var/lib/syncthing/Camera";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/reveng" = {
    device = "tank/nixos/var/lib/syncthing/reveng";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Music" = {
    device = "tank/nixos/var/lib/syncthing/Music";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems."/var/lib/syncthing/Documents" = {
    device = "tank/nixos/var/lib/syncthing/Documents";
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

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/b50f9cff-552d-4c6e-bda2-104723ee638e";
    fsType = "vfat";
  };
  fileSystems."/boot2" = {
    device = "/dev/disk/by-partuuid/6f365c6a-63a2-4fb9-976b-ec9e04c9cb13";
    fsType = "vfat";
  };
  fileSystems."/boot3" = {
    device = "/dev/disk/by-partuuid/324146ea-edb6-4f2e-b260-af8eddfb1eca";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/3b652a7e-a550-4342-a0d7-d2ae47b3e9d1";
      randomEncryption = true;
    }
    {
      device = "/dev/disk/by-partuuid/59de36d4-6613-4b50-9643-8824e9a9b1f9";
      randomEncryption = true;
    }
    {
      device = "/dev/disk/by-partuuid/f6260d75-2b96-4f55-ba0f-050c58b84b78";
      randomEncryption = true;
    }
  ];
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
    br0.interfaces = [ "enp8s0" "wlp6s0" ];
  };
  networking.wireguard.interfaces."wg0".ips = [ "fd0d:a262:1fa6:e621:bc9b:6a33:86e4:873b/64" ];
  networking.nameservers = [ "192.168.2.1" ];
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
  hardware.enableRedistributableFirmware = true;
  nix.settings.substituters = lib.mkForce [
    "https://cache.nixos.org/"
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
  hardware.nvidia.prime.offload.enable = false;
  services.xserver.videoDrivers = [ "nvidia" ];
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix { desktop = false; inherit args; };

  networking.tc_cake = {
    enp1s0f0u4 = {
      disableOffload = true;
      shapeEgress = {
        bandwidth = "4mbit";
        extraArgs = "docsis nat ack-filter";
      };
      shapeIngress = {
        bandwidth = "33mbit";
        ifb = "ifb4enp1s0f0u4";
      };
    };
  };
}
