{
  lib,
  ...
}:
{
  # For legacy pc reason, this needs to be grub
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    efiInstallAsRemovable = true;
    efiSupport = true;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
