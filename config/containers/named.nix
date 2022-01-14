{ ... }: {
  containers."named" = {
    autoStart = true;
    config = {
      services.bind = {
        enable = true;
        forwarders = [
          "2a01:4f8:c17:14df::1"
        ];
        cacheNetworks = [ "0.0.0.0/0" "::/0" ];
      };
      system.stateVersion = "21.11";
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
