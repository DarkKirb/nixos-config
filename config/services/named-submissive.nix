{
  pkgs,
  config,
  dns,
  hosts-list,
  ...
}: let
  internalIP = import ../../utils/getInternalIP.nix config;
  createListenEntry = ip: "inet ${ip} port 8653 allow { any; };";
  listenEntries = builtins.map createListenEntry internalIP.listenIPsBare;
  mkZone = name: {
    master = false;
    masters = ["fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49"];
    file = "/var/lib/named/${name}";
  };
in {
  services.bind = {
    enable = true;
    zones = {
      "darkkirb.de" = mkZone "darkkirb.de";
      "_acme-challenge.darkkirb.de" = mkZone "_acme-challenge.darkkirb.de";
      "chir.rs" = mkZone "chir.rs";
      "_acme-challenge.chir.rs" = mkZone "_acme-challenge.chir.rs";
      "int.chir.rs" = mkZone "int.chir.rs";
      "_acme-challenge.int.chir.rs" = mkZone "_acme-challenge.int.chir.rs";
      "shitallover.me" = mkZone "shitallover.me";
      "_acme-challenge.shitallover.me" = mkZone "_acme-challenge.shitallover.me";
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
      dnssec-validation yes;
      allow-notify { 130.162.60.127; 2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49; 138.201.155.128; 2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49; fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49; };
    '';
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.prometheus.exporters.bind = {
    enable = true;
    bindGroups = ["server" "view" "tasks"];
    bindURI = "http://${internalIP.listenIP}:8653/";
    listenAddress = internalIP.listenIP;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/named 4700 named named - -"
  ];
}
