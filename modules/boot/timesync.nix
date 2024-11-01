{
  config,
  lib,
  ...
}:
with lib; {
  options.boot.initrd.timesync = {
    enable = mkEnableOption "Enables time synchronization in initrd";
  };

  config = mkIf config.boot.initrd.timesync.enable {
    boot.initrd.systemd.users.systemd-timesync = {
      uid = config.users.users.systemd-timesync.uid;
    };
    boot.initrd.systemd.network = {
      enable = true;
      wait-online.enable = true;
    };
    boot.initrd.systemd.services.sync-time = {
      description = "Network Time Synchronization";
      wantedBy = [
        "initrd.target"
        "rootfs-cleanup.service"
      ];
      wants = [
        "network-online.target"
      ];
      after = [
        "network-online.target"
      ];
      before = [
        "rootfs-cleanup.service"
      ];
      unitConfig.DefaultDependencies = "no";
      environment.SYSTEMD_NSS_RESOLVE_VALIDATE = "0";
      serviceConfig.ExecStart = "${config.boot.initrd.systemd.package}/lib/systemd/systemd-timesyncd";
    };
    boot.initrd.systemd.storePaths = [
      config.boot.initrd.systemd.services.sync-time.serviceConfig.ExecStart
    ];
  };
}
