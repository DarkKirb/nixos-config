{ ... }: {
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
  };
}
