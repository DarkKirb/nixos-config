{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [
    "tank"
    "ssd"
    "hdd"
  ];
  services.zfs.autoSnapshot.enable = true;
  boot.kernelParams = [ "nohibernate" ];
  boot.zfs.package = pkgs.zfs_unstable;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
}
