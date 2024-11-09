{ system, ... }:
let
  isx86 = system == "x86_64-linux";
in
{
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = isx86;
    netbootxyz.enable = isx86;
    edk2-uefi-shell.enable = isx86;
  };
  boot.loader.generic-extlinux-compatible.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
}
