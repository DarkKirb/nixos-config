{
  nixos-config,
  lib,
  config,
  ...
}:
{
  networking.hostName = "instance-20221213-1915";
  networking.hostId = "746d4523";
  # This has a weird impermanence setup that has been broken for a long time…
  environment.impermanence.enable = false;

  imports = [
    "${nixos-config}/config"
    ./hardware.nix
    "${nixos-config}/services/named/submissive.nix"
    "${nixos-config}/services/atticd"
    ./postgresql.nix
    "${nixos-config}/services/uptime-kuma.nix"
    "${nixos-config}/services/reverse-proxy.nix"
    "${nixos-config}/services/forgejo"
    "${nixos-config}/services/chir-rs"
  ];

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/acme - - - - /persist/var/lib/acme"
    "L /var/lib/tailscale/tailscaled.state - - - - /persist/var/lib/tailscale/tailscaled.state"
    "d /build - - - - -"
    "L /var/lib/ipfs - - - - /persist/var/lib/ipfs"
    "L /var/lib/uptime-kuma - - - - /persist/var/lib/uptime-kuma"
  ];
  services.postgresql.dataDir = "/persist/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
  nix.settings.cores = 4;
  nix.settings.max-jobs = 4;
  nix.settings.system-features = [
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-armv8-a"
    "gccarch-armv8.1-a"
    "gccarch-armv8.2-a"
    "ca-derivations"
  ];
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  system.stateVersion = "22.11";
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/ssh/ssh_host_ed25519_key" ];
  services.bind.forwarders = lib.mkForce [ ];
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;
  services.tailscale.useRoutingFeatures = "server";
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
  nixpkgs.config.allowUnfree = true;
}
