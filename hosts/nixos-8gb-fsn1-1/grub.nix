{ ... }: {
  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      devices = [ "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0" ];
    };
    timeout = 5;
  };
}
