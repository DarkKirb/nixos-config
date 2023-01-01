{pkgs, ...}: {
  programs.mako = {
    enable = true;
    defaultTimeout = 30000;
  };
  systemd.user.services.mako = {
    Unit = {
      Description = "mako";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "mako";
    };
  };
}
