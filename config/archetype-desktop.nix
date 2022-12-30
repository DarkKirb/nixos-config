{
  imports = [
    ./desktop.nix
    ./systemd-boot.nix
  ];
  fileSystems."/" = {
    device = "tank/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6557-C4A0";
    fsType = "vfat";
  };
}
