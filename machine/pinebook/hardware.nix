{
  lib,
  pkgs,
  ...
}:
{
  hardware.deviceTree.name = "allwinner/sun50i-a64-pinebook.dtb";
  hardware.deviceTree.filter = "sun50i-a64-pinebook.dtb";
  hardware.deviceTree.overlays = [
  ];
  boot.initrd.systemd.tpm2.enable = lib.mkForce false;
  systemd.tpm2.enable = lib.mkForce false;
  services.xserver.videoDrivers = lib.mkBefore [
    "modesetting" # Prefer the modesetting driver in X11
    "fbdev" # Fallback to fbdev
  ];
}
