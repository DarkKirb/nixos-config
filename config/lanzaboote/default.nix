{
  lanzaboote,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  sops.secrets."var/lib/sbctl/GUID" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/GUID";
  };
  sops.secrets."var/lib/sbctl/keys/db/db.key" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/db/db.key";
  };
  sops.secrets."var/lib/sbctl/keys/db/db.pem" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/db/db.pem";
  };
  sops.secrets."var/lib/sbctl/keys/KEK/KEK.key" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/KEK/KEK.key";
  };
  sops.secrets."var/lib/sbctl/keys/KEK/KEK.pem" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/KEK/KEK.pem";
  };
  sops.secrets."var/lib/sbctl/keys/PK/PK.key" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/PK/PK.key";
  };
  sops.secrets."var/lib/sbctl/keys/PK/PK.pem" = {
    sopsFile = ./secrets.yaml;
    path = "/var/lib/sbctl/keys/PK/PK.pem";
  };

}
