{
  security.pam.services.sddm.u2fAuth = true;
  services.xserver = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
    #desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "plasma";
    #displayManager.defaultSession = "plasmawayland";
  };
}
