{
  disko.devices = {
    disk = {
      installer = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD10SPZX-22Z10T0_WD-WXL1A87JL6DC";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/root" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "/persistent" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/persistent";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                };
                mountpoint = "/partition-root";
              };
            };
          };
        };
      };
    };
  };
}
