{ ... }: {
  services.restic.backups."sysbackup" = {
    passwordFile = "/run/secrets/security/restic/password";
    paths = [
      "/var"
      "/home"
    ];
    repository = "sftp:darkkirb@[fd00:e621:e621:2::2]:/backup";
  };
}
