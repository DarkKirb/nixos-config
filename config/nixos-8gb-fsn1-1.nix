{ config, pkgs, lib, modulesPath, ... }: {
  networking.hostName = "nixos-8gb-fsn1-1";
  networking.hostId = "73561e1f";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./grub.nix
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = ["zfs_force=1"]; # Remove after next boot
  boot.loader.grub.devices = "/dev/disk/by-diskuuid/2b59a132-a2ca-5049-bf54-9bd372cea2e8";

  fileSystems."/" =
    { device = "tank/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    { device = "tank/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/etc" =
    { device = "tank/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    { device = "tank/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib" =
    { device = "tank/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/log" =
    { device = "tank/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/spool" =
    { device = "tank/nixos/var/spool";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    { device = "tank/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root" =
    { device = "tank/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/darkkirb" =
    { device = "tank/userdata/home/darkkirb";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/miifox" =
    { device = "tank/userdata/home/miifox";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8E14-4366";
      fsType = "vfat";
      options = [ "X-mount.mkdir" ];
    };

  swapDevices = [ ];

  system.stateVersion = "21.11";
}
