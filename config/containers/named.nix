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
            file = "darkkirb.de.zone";
          };
          "chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
            file = "chir.rs.zone";
          };
          "int.chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
            file = "int.chir.rs.zone";
          };
          "rpz.int.chir.rs" = {
            master = false;
            masters = [
              "fd00:e621:e621::1"
            ];
            file = "rpz.int.chir.rs.zone";
          };
        };
      };
      system.stateVersion = "21.11";
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
