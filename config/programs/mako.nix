{pkgs, ...}: {
  systemd.user.services.mako = {
    Unit = {
      Description = "mako";
    };
    Service = {
      ExecStart = "${pkgs.mako}/bin/mako --default-timeout 30000";
    };
  };
}
