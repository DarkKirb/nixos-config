{ nixos-config, lib, ... }:
{
  networking.hostName = "nas";
  networking.hostId = "70af00ed";
  environment.impermanence.enable = false;

  imports = [
    "${nixos-config}/config"
    ./hardware.nix
    "${nixos-config}/services/hydra"
    ./syncthing.nix
    "${nixos-config}/services/loki.nix"
    "${nixos-config}/services/prometheus"
    "${nixos-config}/services/yiffstash"
    "${nixos-config}/services/reverse-proxy.nix"
    "${nixos-config}/services/jellyfin.nix"
    "${nixos-config}/services/forgejo-runner"
    "${nixos-config}/services/renovate"
    "${nixos-config}/services/chir-rs"
    ./restic-monitor.nix
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
  ];
  services.caddy.enable = true;
  sops.age.sshKeyPaths = lib.mkForce [ "/etc/ssh/ssh_host_ed25519_key" ];
}
