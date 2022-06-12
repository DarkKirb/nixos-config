{...}: {
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
  };
  networking.firewall.interfaces."wg0".allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.interfaces."wg0".allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
}
