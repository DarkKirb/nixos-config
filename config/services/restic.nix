{ ... }: {
  services.restic.backups."sysbackup" = {
    passwordFile = "/run/secrets/security/restic/password";
    paths = [
      "/var"
      "/home"
    ];
    repository = "sftp:darkkirb@backup.int.chir.rs:/backup";
  };
}
