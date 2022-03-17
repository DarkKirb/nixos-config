{ ... }: {
  fileSystems = {
    "/" = {
      device = "ssd/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "ssd/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/etc" = {
      device = "ssd/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var" = {
      device = "ssd/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/lib" = {
      device = "ssd/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/log" = {
      device = "ssd/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/spool" = {
      device = "ssd/nixos/var/spool";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "ssd/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/root" = {
      device = "ssd/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home/tank" = {
      device = "ssd/userdata/home/tank";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home/darkkirb/hdd" = {
      device = "hdd/userdata/home/darkkirb/hdd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/root/hdd" = {
      device = "hdd/userdata/home/root/hdd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/CA0B-E049";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/110ae65d-8ea1-214d-bd7b-a6f3e1b5dc3a";
      randomEncryption = true;
    }
  ];
}
