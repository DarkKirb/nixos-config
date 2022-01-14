{ ... }: {
  containers."named" = {
    autoStart = true;
    config = {
      services.bind = {
        enable = true;
        zones = {
          "darkkirb.de" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
          };
          "chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
          };
          "int.chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
          };
          "rpz.int.chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
          };
        };
      };
      system.stateVersion = "21.11";
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
