{ lib, pkgs, ... }:
{
  networking.hostName = "nas";
  networking.hostId = "70af00ed";
  environment.impermanence.enable = false;

  imports = [
    ../../config
    ./hardware.nix
    ../../services/hydra
    ./syncthing.nix
    ../../services/loki.nix
    ../../services/prometheus
    ../../services/yiffstash
    ../../services/reverse-proxy.nix
    ../../services/renovate
    ../../services/chir-rs
    ./postgresql.nix
    ./youtube-update.nix
    ../../services/matrix
    ../../services/kubernetes
  ];

  nix.settings.substituters = lib.mkForce [
    "https://attic.chir.rs/chir-rs/"
    "https://cache.nixos.org/"
  ];

  services.restic.backups.sysbackup.paths = [
    "/var"
    "/home"
    "/root"
  ];
  services.restic.backups.sysbackup.extraBackupArgs = [
    "--exclude"
    "/var/cache"
    "--exclude"
    "/var/tmp"
    "--exclude"
    "/media/Youtube"
  ];
  services.caddy.enable = true;
  sops.age.sshKeyPaths = lib.mkForce [ "/etc/ssh/ssh_host_ed25519_key" ];
}
