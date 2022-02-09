{ config, dns, ... }:
let
  internalIP = import ../../utils/getInternalIP.nix config;
  createListenEntry = ip: "inet ${ip} port 8653 allow { any; };";
  listenEntries = builtins.map createListenEntry internalIP.listenIPsBare;
  chir-rs = import ../../zones/chir.rs.nix { inherit dns; };
  signzone = import ../../zones/signzone.nix;
in
{
  imports = [
    (signzone {
      inherit dns;
      ksk = "services/dns/rs/chir/32969";
      zsk = "services/dns/rs/chir/51207";
      zone = chir-rs;
      zonename = "staging.chir.rs";
    })
  ];

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
      "staging.chir.rs" = {
        master = true;
        file = "/var/lib/named/staging.chir.rs";
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
      };
    '';
    extraOptions = ''
      allow-recursion {
        127.0.0.1;
        ::1;
        fc00::/7;
      };
      recursion yes;
      response-policy {
        zone "rpz.int.chir.rs";
      };
      dnssec-validation yes;
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
