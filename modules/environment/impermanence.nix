{
  impermanence,
  config,
  lib,
  pkgs,
  inTester,
  ...
}:
with lib; {
  imports = ["${impermanence}/nixos.nix"];
  options = {
    environment.impermanence = mkEnableOption "Enables impermanence";
  };

  config = mkMerge [
    {
      environment.impermanence = mkDefault (!config.boot.isContainer && !inTester);
    }
    (mkIf config.environment.impermanence {
      boot.initrd.systemd.services.rootfs-cleanup = {
        description = "Clean file system root";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "initrd-root-device.target"
        ];
        before = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          # workaround for machines without working rtc battery
          # The time may not yet be correctly set, so wait until it is
          if [[ $(date '+%s') -lt 1730469314 ]];
            sleep 30 # this should hopefully be enough
          fi
          mkdir /btrfs_tmp
          mount ${config.fileSystems."/".device} -t btrfs /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
      assertions = [
        {
          assertion = hasAttr "/" config.fileSystems;
          message = "To use impermanence, you need to define a root volume";
        }
        {
          assertion =
            if hasAttr "/" config.fileSystems
            then config.fileSystems."/".fsType == "btrfs"
            else false;
          message = "rootfs must be btrfs";
        }
        {
          assertion =
            if hasAttr "/" config.fileSystems
            then any (t: t == "subvol=root" || t == "subvol=/root") config.fileSystems."/".options
            else false;
          message = "rootfs must mount subvolume root";
        }
      ];
      fileSystems."/persistent" = {
        device =
          if hasAttr "/" config.fileSystems
          then mkDefault config.fileSystems."/".device
          else "/dev/null";
        fsType = "btrfs";
        options = ["subvol=persistent"];
        neededForBoot = true;
      };
      environment.persistence."/persistent" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/nixos"
        ];
        files = [
          "/etc/ssh/ssh_host_ecdsa_key"
          "/etc/ssh/ssh_host_ecdsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
    })
  ];
}
