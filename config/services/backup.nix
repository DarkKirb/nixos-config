{
  config,
  pkgs,
  ...
}: let
  resticPrune = pkgs.writeScript "resticPrune" ''
    #!/bin/sh
    export RESTIC_REPOSITORY="$RESTIC_REPOSITORY-prune"
    ${pkgs.restic}/bin/restic prune --no-cache --max-unused 0
    ${pkgs.restic}/bin/restic check --read-data-subset 10%
  '';
in {
  users.users.backup = {
    description = "Backup user";
    home = "/backup";
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINN5Q/L2FyB3DIgdJRYnTGHW3naw5VQ9coOdwHYmv0aZ darkkirb@thinkrac"
    ];
    group = "backup";
    useDefaultShell = true;
  };
  users.groups.backup = {};
  systemd.services.restic-prune = {
    enable = true;
    description = "Cleaning up restic backups";
    serviceConfig = {
      ExecStart = "${resticPrune}";

      User = "backup";
      Group = "backup";
      Type = "oneshot";

      EnvironmentFile = config.sops.secrets."services/restic/env".path;
    };
  };
  systemd.timers.restic-prune = {
    enable = true;
    description = "Prune restic backups";
    requires = ["restic-prune.service"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = 604800;
    };
  };

  sops.secrets."services/restic/env".owner = "backup";
  sops.secrets."services/restic/rclone.conf" = {
    owner = "backup";
    path = "/backup/.config/rclone/rclone.conf";
  };
  systemd.services.backup-rclone = {
    enable = true;
    description = "Upload backup to remote";
    script = ''
      ${pkgs.rclone}/bin/rclone sync /backup backup:backup-darkkirb-de/backup
    '';
    serviceConfig = {
      User = "backup";
      Group = "backup";
      Type = "oneshot";
    };
  };
  systemd.timers.backup-rclone = {
    enable = true;
    description = "Upload backup to remote";
    requires = ["backup-rclone.service"];
    wantedBy = ["network-online.target"];
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = 604800;
    };
  };
}
