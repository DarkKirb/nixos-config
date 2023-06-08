_: {
  services.restic.backups."sysbackup" = {
    passwordFile = "/run/secrets/security/restic/password";
    paths = [
      "/var"
      "/home"
    ];
    extraBackupArgs = [
      "--exclude-caches"
      "--compression max"
      "--exclude"
      "/var/tmp"
      "--exclude"
      "/var/cache"
      "--exclude"
      "/root/.cache"
      "--exclude"
      "/home/darkkirb/.cache"
      "--exclude"
      "/var/lib/ipfs/root"
    ];
    repository = "sftp:backup@backup.int.chir.rs:/backup";
  };
  sops.secrets."security/restic/password" = {};
}
