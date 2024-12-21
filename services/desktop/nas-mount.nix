{ pkgs, lib, ... }:
{
  xdg.configFile."rclone/rclone.conf".text = ''
    [nas]
    type = sftp
    ssh = ssh darkkirb@nas.int.chir.rs
    shell_type = unix
  '';
  systemd.user.services.nas-mount = {
    Unit = {
      Description = "Nas mount";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} -p %h/nas";
      ExecStart = "${lib.getExe pkgs.rclone} --vfs-cache-mode writes mount \"nas:\" \"%h/nas\"";
      ExecStop = "/run/wrappers/bin/fusermount -u %h/nas";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
