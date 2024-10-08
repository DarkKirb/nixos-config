{
  security.pam.services.sddm.u2fAuth = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };
  services.xserver = {
    #desktopManager.plasma6.enable = true;
    desktopManager.plasma5.enable = true;
    #displayManager.defaultSession = "plasma";
    displayManager.defaultSession = "plasmawayland";
  };
}
