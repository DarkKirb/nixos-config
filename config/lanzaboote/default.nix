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
    pkiBundle = "/run/secrets/var/lib/sbctl";
  };

  sops.secrets."var/lib/sbctl/GUID".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/db/db.key".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/db/db.pem".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/KEK/KEK.key".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/KEK/KEK.pem".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/PK/PK.key".sopsFile = ./secrets.yaml;
  sops.secrets."var/lib/sbctl/keys/PK/PK.pem".sopsFile = ./secrets.yaml;
}
