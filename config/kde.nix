{
  security.pam.services.sddm.u2fAuth = true;
  services.xserver = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.defaultSession = "plasma";
  };
}
