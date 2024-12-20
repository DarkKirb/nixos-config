{ pkgs, ... }:
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
      ExecStartPre = "/usr/bin/env mkdir -p %h/nas";
      ExecStart = "${pkgs.rclone}/bin/rclone --vfs-cache-mode writes mount \"nas:\" \"%h/nas\"";
      ExecStop = "/bin/fusermount -u %h/nas";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
