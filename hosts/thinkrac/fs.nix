{ ... }: {
  boot.supportedFilesystems = [ "bcachefs" ];
  fileSystems = {
    "/" = {
      device = "/dev/mapper/disk";
      fsType = "bcachefs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9052-28BA";
      fsType = "vfat";
    };
  };
}
