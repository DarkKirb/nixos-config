{
  pkgs,
  lib,
  ...
}:
{
  disko = {
    devices = {
      disk = {
        disk1 = {
          imageSize = "64G";
          type = "disk";
          device = "/dev/mmcblk1";
          content = {
            type = "gpt";
            preMountHook = ''
              ${lib.getExe' pkgs.coreutils "dd"} if=${pkgs.ubootPinebook}/u-boot-sunxi-with-spl.bin of=/dev/mmcblk1 bs=1k seek=128
            '';
            partitions = {
              boot = {
                start = "4096";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
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
  };
}
