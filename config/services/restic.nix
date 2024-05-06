{config, ...}: {
  services.restic.backups."sysbackup" = {
    timerConfig = {
      OnUnitActiveSec = "12h";
      RandomizedDelaySec = "1d";
      Persistent = true;
    };
    environmentFile = config.sops.secrets."security/restic/env".path;
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
    repository = "s3://ams1.vultrobjects.com/backup-chir-rs";
    passwordFile = config.sops.secrets."security/restic/password".path;
  };
  sops.secrets."security/restic/env" = {
    sopsFile = ../../secrets/shared.yaml;
  };
  sops.secrets."security/restic/password" = {
    sopsFile = ../../secrets/shared.yaml;
  };
}
