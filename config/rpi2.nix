_: {
  networking.hostName = "rpi2";
  networking.hostId = "29d7b964";
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  system.stateVersion = "21.11";
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix false;
  nix.settings.cores = 4;
}
