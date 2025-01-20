{ nixos-config, lib, ... }:
{
  networking.hostName = "nixos-8gb-fsn1-1";
  networking.hostId = "73561e1f";
  environment.impermanence.enable = false;

  imports = [
    "${nixos-config}/config"
    ./hardware.nix
    "${nixos-config}/services/named/dominant.nix"
    "${nixos-config}/services/grafana.nix"
    "${nixos-config}/services/reverse-proxy.nix"
    "${nixos-config}/services/akkoma"
    "${nixos-config}/services/peertube"
    ./initrd-ssh.nix
    ./postgresql.nix
    "${nixos-config}/services/chir-rs"
  ];

  services.resolved.enable = false;
  services.bind.forwarders = lib.mkForce [ ];
  services.caddy.virtualHosts."darkkirb.de" = {
    useACMEHost = "darkkirb.de";
    extraConfig = ''
      redir https://lotte.chir.rs
    '';
  };
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
  nix.auto-update.reboot = false;
}
