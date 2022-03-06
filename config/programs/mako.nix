{ pkgs, ... }: {
  systemd.user.services.mako = {
    Unit = {
      Description = "mako";
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.mako}/bin/mako --default-timeout 30000";
    };
  };
}
