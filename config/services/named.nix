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
  darkkirb-de = import ../../zones/darkkirb.de.nix {inherit dns;};
  chir-rs = import ../../zones/chir.rs.nix {inherit dns;};
  int-chir-rs = import ../../zones/int.chir.rs.nix {inherit dns;};
  rpz-int-chir-rs = import ../../zones/rpz.int.chir.rs.nix {inherit pkgs hosts-list;};
  signzone = import ../../zones/signzone.nix;
in {
  imports = [
    (signzone {
      inherit dns;
      ksk = "services/dns/rs/chir/32969";
      zsk = "services/dns/rs/chir/51207";
      zone = chir-rs;
      zonename = "chir.rs";
    })
    (signzone {
      inherit dns;
      ksk = "services/dns/rs/chir/int/35133";
      zsk = "services/dns/rs/chir/int/19631";
      zone = int-chir-rs;
      zonename = "int.chir.rs";
    })
    (signzone {
      inherit dns;
      ksk = "services/dns/de/darkkirb/53136";
      zsk = "services/dns/de/darkkirb/61825";
      zone = darkkirb-de;
      zonename = "darkkirb.de";
    })
  ];

  services.bind = {
    enable = true;
    zones = {
      "darkkirb.de" = {
        master = true;
        file = "/var/lib/named/darkkirb.de";
      };
      "_acme-challenge.darkkirb.de" = {
        master = true;
        file = "/var/lib/named/_acme-challenge.darkkirb.de";
        extraConfig = ''
          update-policy {
            grant certbot. name _acme-challenge.darkkirb.de. txt;
          };
        '';
      };
      "chir.rs" = {
        master = true;
        file = "/var/lib/named/chir.rs";
      };
      "_acme-challenge.chir.rs" = {
        master = true;
        file = "/var/lib/named/_acme-challenge.chir.rs";
        extraConfig = ''
          update-policy {
            grant certbot. name _acme-challenge.chir.rs. txt;
          };
        '';
      };
      "int.chir.rs" = {
        master = true;
        file = "/var/lib/named/int.chir.rs";
      };
      "_acme-challenge.int.chir.rs" = {
        master = true;
        file = "/var/lib/named/_acme-challenge.int.chir.rs";
        extraConfig = ''
          update-policy {
            grant certbot. name _acme-challenge.int.chir.rs. txt;
          };
        '';
      };
      "rpz.int.chir.rs" = {
        master = true;
        file = "${rpz-int-chir-rs}";
      };
    };
    extraConfig = ''
      statistics-channels {
        ${toString listenEntries}
      };
      include "/run/secrets/services/dns/named-keys";
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
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.prometheus.exporters.bind = {
    enable = true;
    bindGroups = ["server" "view" "tasks"];
    bindURI = "http://${internalIP.listenIP}:8653/";
    listenAddress = internalIP.listenIP;
  };
  sops.secrets."services/dns/named-keys" = {owner = "named";};
}
