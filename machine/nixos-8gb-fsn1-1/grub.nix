{
  lib,
  ...
}:
{
  # For legacy pc reason, this needs to be grub
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    memtest86.enable = true;
  };
}
