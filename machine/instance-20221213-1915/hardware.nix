{ modulesPath, nixos-config, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    "${nixos-config}/config/zfs.nix"
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "tank/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6557-C4A0";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "tank/local/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "tank/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "tank/safe/home";
    fsType = "zfs";
  };

}
