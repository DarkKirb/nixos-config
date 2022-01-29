{ config, pkgs, modulesPath, lib, ... }: {
  networking.hostName = "thinkrac";
  networking.hostId = "2bfaea87";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
  ];
  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "tank" ];

  boot.initrd.luks.devices = {
    disk = {
      device = "/dev/disk/by-partuuid/7da5a9f1-abcc-ac4f-837c-806d1de2e3ce";
      allowDiscards = true;
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

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/9052-28BA";
      fsType = "vfat";
    };

  networking.interfaces.enp0s31f6.useDHCP = true;
  system.stateVersion = "21.11";
  networking.wireguard.interfaces."wg0".ips = [
    "fd0d:a262:1fa6:e621:f45a:db9f:eb7c:1a3f/64"
  ];
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix true;
  networking.nameservers = [ "fd00:e621:e621:2::2" ];
  services.xserver.videoDrivers = [ "intel" ];
  nix.binaryCaches = lib.mkForce [
    "http://192.168.2.1:9000/cache.int.chir.rs/"
  ];
  nix.buildCores = 4;
}
