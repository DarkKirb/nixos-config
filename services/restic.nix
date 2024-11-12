{ config, ... }:
{
  services.restic.backups.sysbackup = {
    timerConfig = {
      OnCalendar = "06:00";
      RandomizedDelaySec = "12h";
    };
    environmentFile = config.sops.secrets."services/restic/backups/sysbackup/environment".path;
    paths = [
      "/persistent"
    ];
    extraBackupArgs = [
      "--exclude-caches"
      "--compression max"
      "--exclude"
      "/persistent/var/cache"
      "--exclude"
      "/persistent/home/root/.cache"
      "--exclude"
      "/persistent/home/darkkirb/.cache"
    ];
    repository = "s3://ams1.vultrobjects.com/backup-chir-rs";
    passwordFile = config.sops.secrets."services/restic/backups/sysbackup/password".path;
  };
  sops.secrets."services/restic/backups/sysbackup/environment".sopsFile = ./restic.yaml;
  sops.secrets."services/restic/backups/sysbackup/password".sopsFile = ./restic.yaml;
}
