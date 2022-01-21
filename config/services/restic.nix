{ ... }: {
  services.restic.backups."sysbackup" = {
    passwordFile = "/run/secrets/security/restic/password";
    paths = [
      "/var"
      "/home"
    ];
    extraBackupArgs = [
      "--exclude-caches"
      "--exclude=/var/lib/minio/disk0/cache.int.chir.rs" # Cache files, don’t need backups since they are automatically deleted anyways…
      "--exclude=/var/lib/minio/disk1/cache.int.chir.rs"
      "--exclude=/var/lib/minio/disk2/cache.int.chir.rs"
      "--exclude=/var/lib/minio/disk3/cache.int.chir.rs"
    ];
    repository = "sftp:darkkirb@backup.int.chir.rs:/backup";
  };
  sops.secrets."security/restic/password" = { };
}
