{
  config,
  dns,
  ...
}:
let
  chir-rs = import ./chir.rs.nix { inherit dns; };
  int-chir-rs = import ./int.chir.rs.nix { inherit dns; };
  signzone = import ./signzone.nix;
in
{
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
  ];

  services.bind = {
    enable = true;
    zones = {
      "chir.rs" = {
        master = true;
        file = "/var/lib/named/chir.rs";
        slaves = [
          "fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b"
          "100.99.173.107"
        ];
        extraConfig = "also-notify {fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b; 100.99.173.107;};";
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
        slaves = [
          "fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b"
          "100.99.173.107"
        ];
        extraConfig = "also-notify {fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b; 100.99.173.107;};";
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
    };
    extraConfig = ''
      statistics-channels {
        inet 127.0.0.1 port 8653 allow { 127.0.0.1; };
      };
      include "/run/secrets/services/dns/named-keys";
    '';
    extraOptions = ''
      allow-recursion {
        127.0.0.1;
        ::1;
        fc00::/7;
        100.0.0.0/8;
      };
      recursion yes;
      dnssec-validation auto;
      allow-transfer {fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b; 100.99.173.107;};
      notify-delay 0;
    '';
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.prometheus.exporters.bind = {
    enable = true;
    bindGroups = [
      "server"
      "view"
      "tasks"
    ];
    bindURI = "http://127.0.0.1:8653/";
    port = 1533;
  };
  sops.secrets."services/dns/named-keys" = {
    sopsFile = ./secrets.yaml;
    owner = "named";
  };
}
