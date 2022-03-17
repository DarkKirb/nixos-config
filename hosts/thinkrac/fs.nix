{ ... }: {
  fileSystems = {
    "/" = {
      device = "tank/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "tank/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/etc" = {
      device = "tank/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var" = {
      device = "tank/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/lib" = {
      device = "tank/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/log" = {
      device = "tank/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var/spool" = {
      device = "tank/nixos/var/spool";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "tank/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/root" = {
      device = "tank/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home/darkkirb" = {
      device = "tank/userdata/home/darkkirb";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9052-28BA";
      fsType = "vfat";
    };

  };
}
