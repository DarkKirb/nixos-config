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
    ];
    repository = "sftp:backup@backup.int.chir.rs:/backup";
  };
  sops.secrets."security/restic/password" = {};
}
