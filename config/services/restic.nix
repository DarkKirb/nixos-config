{ ... }: {
  services.restic.backups."sysbackup" = {
    passwordFile = "/run/secrets/security/restic/password";
    paths = [
      "/var"
      "/home"
    ];
    repository = "sftp:darkkirb@localhost:/backup";
  };
}
