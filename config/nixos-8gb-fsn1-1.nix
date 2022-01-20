{ config, pkgs, lib, modulesPath, ... }: {
  networking.hostName = "nixos-8gb-fsn1-1";
  networking.hostId = "73561e1f";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./grub.nix
    ./server.nix
    ./services/named.nix
    ./services/grafana.nix
    ./users/miifox.nix
    ./services/postgres.nix
    ./services/gitea.nix
    ./services/old-homepage.nix
    ./services/chir-rs.nix
    ./services/postfixadmin.nix
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.devices = [ "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0" ];
  boot.loader.timeout = 5;
  boot.initrd.luks.devices = {
    disk0 = {
      device = "/dev/disk/by-partuuid/29ccd4c9-5ef5-a146-8e42-9244f712baca";
    };
  };

  fileSystems."/" =
    {
      device = "tank/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    {
      device = "tank/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/etc" =
    {
      device = "tank/nixos/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    {
      device = "tank/nixos/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib" =
    {
      device = "tank/nixos/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib/minio" = {
    device = "tank/nixos/var/lib/minio";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/minio/disk0" = {
    device = "tank/nixos/var/lib/minio/disk0";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/minio/disk1" = {
    device = "tank/nixos/var/lib/minio/disk1";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/minio/disk2" = {
    device = "tank/nixos/var/lib/minio/disk2";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/minio/disk3" = {
    device = "tank/nixos/var/lib/minio/disk3";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/log" =
    {
      device = "tank/nixos/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/spool" =
    {
      device = "tank/nixos/var/spool";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    {
      device = "tank/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root" =
    {
      device = "tank/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/darkkirb" =
    {
      device = "tank/userdata/home/darkkirb";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/miifox" =
    {
      device = "tank/userdata/home/miifox";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8E14-4366";
      fsType = "vfat";
      options = [ "X-mount.mkdir" ];
    };

  swapDevices = [ ];

  system.stateVersion = "21.11";

  systemd.network = {
    enable = true;
    networks."enp0s3".extraConfig = ''
      [Match]
      Name = ens3
      [Network]
      Address = 2a01:4f8:1c17:d953:b4e1:08ff:e658:6f49/64
      Gateway = fe80::1
    '';
  };

  networking.wireguard.interfaces."wg0".ips = [ "fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49/64" ];
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix false;
}
