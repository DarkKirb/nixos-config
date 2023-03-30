_: {
  services.syncthing = {
    enable = true;
    guiAddress = "[::]:8384";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [8384];
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000];
}
