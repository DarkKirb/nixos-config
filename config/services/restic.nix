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
    repository = "sftp:backup:/backup";
  };
  sops.secrets."security/restic/env" = {
    sopsFile = ../../secrets/shared.yaml;
  };
}
