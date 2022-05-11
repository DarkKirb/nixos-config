{ pkgs, ... }: {
  home.packages = [ pkgs.keepassxc ];
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "keepassxc";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
    };
  };
}
