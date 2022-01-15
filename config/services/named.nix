{ config, ... }:
let
  internalIP = import ../../utils/getInternalIP.nix config;
  createListenEntry = ip: "inet ${ip} port 8653 allow { ${ip} };";
  listenEntries = builtins.map createListenEntry internalIP.listenIPsBare;
in
{
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
    extraConfig = ''
      statistics-channels {
        ${toString listenEntries}
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.prometheus.exporters.bind = {
    enable = true;
    bindGroups = [ "server" "view" "tasks" ];
    bindURI = "http://${internalIP.listenIP}:8653/";
    listenAddress = internalIP.listenIP;
  };
}
