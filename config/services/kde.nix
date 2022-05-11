{ ... }: {
  services.xserver = {
    enable = true;
    desktopManager.plasma.enable = true;
    displayManager.sddm.enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
  };
}
