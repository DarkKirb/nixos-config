{
  config,
  pkgs,
  ...
}: let
  resticPrunePre = pkgs.writeScript "resticPrunePre" ''
    set -ex

    # Recover from an unclean shutdown
    if ${pkgs.zfs}/bin/zfs list tank/backup-old; then
      ${pkgs.zfs}/bin/zfs list tank/backup || ${pkgs.zfs}/bin/zfs rename tank/backup-old tank/backup
    fi

    # Undo a prune that has been aborted
    ${pkgs.zfs}/bin/zfs destroy tank/backup-prune || true
    ${pkgs.zfs}/bin/zfs destroy tank/backup@prune || true
    ${pkgs.zfs}/bin/zfs destroy tank/backup-old || true

    # Wait for the restic repository to be unlocked
    while [ -n "$(${pkgs.restic}/bin/restic list locks)" ]; then
      sleep 10
    fi

    # Clone the Dataset
    ${pkgs.zfs}/bin/zfs snapshot tank/backup@prune
    ${pkgs.zfs}/bin/zfs clone -o mountpoint=/backup-prune tank/backup@prune tank/backup-prune
    chown backup:backup /backup-prune
  '';
  resticPrune = pkgs.writeScript "resticPrune" ''
    export RESTIC_REPOSITORY="$RESTIC_REPOSITORY-prune"
    ${pkgs.restic}/bin/restic prune --no-cache --max-unused 0
    ${pkgs.restic}/bin/restic check --read-data-subset 10%
  '';
  resticPrunePost = pkgs.writeScript "resticPrunePost" ''
    set -ex

    # Wait for the restic repository to be unlocked
    while [ -n "$(${pkgs.restic}/bin/restic list locks)" ]; then
      sleep 10
    fi

    # make the original read-only
    ${pkgs.zfs}/bin/zfs set readonly=on tank/backup

    # Copy new data over
    ${pkgs.restic}/bin/restic copy --no-cache --no-lock

    # Promote the pruned dataset
    ${pkgs.zfs}/bin/zfs promote tank/backup-prune

    # Change the dataset names
    ${pkgs.zfs}/bin/zfs rename tank/backup tank/backup-old
    ${pkgs.zfs}/bin/zfs rename tank/backup-prune tank/backup

    # Change the mount point
    ${pkgs.zfs}/bin/zfs set mountpoint=/backup tank/backup

    # Destroy the old dataset
    ${pkgs.zfs}/bin/zfs destroy -rf tank/backup-old
    ${pkgs.zfs}/bin/zfs destroy tank/backup@prune
    ${pkgs.zfs}/bin/zfs mount tank/backup
  '';
in {
  users.users.backup = {
    description = "Backup user";
    home = "/backup";
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN/rVZJuwiO44LwOqimpH4zyGehYUMF2ZhYFXUCkupP hydra-queue-runner@nas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuWXwZAQYnC2oso7In6BNNM3H+Ek7s6ygIuEvqE3YUf root@nutty-noon"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpO0Lh7eOE/EBttb/XWZ6ISiJ0RkmBYfruq3U6linEz root@nixos-8gb-fsn1-1"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKB8oH1XbuGrKn/SeguXz96sw4AjJQQvZyAdpptotzOr root@thinkrac"
    ];
    group = "backup";
    useDefaultShell = true;
  };
  users.groups.backup = {};
  systemd.services.restic-prune = {
    enable = true;
    description = "Cleaning up restic backups";
    serviceConfig = {
      ExecStartPre = "!${resticPrunePre}";
      ExecStart = "${resticPrune}";
      ExecStartPost = "!${resticPrunePost}";

      User = "backup";
      Group = "backup";
      Type = "oneshot";

      EnvironmentFile = config.sops.secrets."services/restic/env".owner;
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
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 86400;
    };
  };
}
