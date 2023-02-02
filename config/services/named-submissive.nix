{
  pkgs,
  config,
  dns,
  hosts-list,
  ...
}: let
  internalIP = import ../../utils/getInternalIP.nix config;
  mkZone = name: {
    master = false;
    masters = ["100.119.226.33" "fd7a:115c:a1e0:ab12:4843:cd96:6277:e221"];
    file = "/var/lib/named/${name}";
  };
in {
  services.bind = {
    enable = true;
    zones = {
      "darkkirb.de" = mkZone "darkkirb.de";
      "chir.rs" = mkZone "chir.rs";
      "int.chir.rs" = mkZone "int.chir.rs";
      "rpz.int.chir.rs" = mkZone "rpz.int.chir.rs";
      "shitallover.me" = mkZone "shitallover.me";
    };
    extraConfig = ''
      statistics-channels {
        inet 127.0.0.1 port 8653 allow { 127.0.0.1; };
      };
    '';
    extraOptions = ''
      allow-recursion {
        127.0.0.1;
        ::1;
        fc00::/7;
        100.0.0.0/8;
      };
      recursion yes;
      dnssec-validation yes;
      allow-notify { 130.162.60.127; 2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49; 138.201.155.128; 2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49; fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49; 100.119.226.33; fd7a:115c:a1e0:ab12:4843:cd96:6277:e221; };
      response-policy {zone "rpz.int.chir.rs";};
    '';
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.prometheus.exporters.bind = {
    enable = true;
    bindGroups = ["server" "view" "tasks"];
    bindURI = "http://127.0.0.1:8653/";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/named 4700 named named - -"
  ];
}
