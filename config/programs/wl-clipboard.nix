{pkgs, ...}: {
  systemd.user.services.wl-clipboard = {
    Unit = {
      Description = "wl-clipboard";
      PartOf = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.clipman}/bin/clipman store --no-persist";
    };
  };
}
