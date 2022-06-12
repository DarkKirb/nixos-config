{...}: {
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [3100];
}
