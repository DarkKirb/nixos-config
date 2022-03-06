{ pkgs, ... }:
let
  plover-src = pkgs.plover.dev.src;
in
{
  home.packages = [
    pkgs.plover.dev
  ];
  home.file = {
    ".config/plover/main.json" = {
      source = "${plover-src}/plover/assets/main.json";
      onChange = "${pkgs.systemd}/bin/systemctl restart --user plover";
    };
    ".config/plover/commands.json" =
      {
        source = "${plover-src}/plover/assets/commands.json";
        onChange = "${pkgs.systemd}/bin/systemctl restart --user plover";
      };
    ".config/plover/user.json" = {
      text = builtins.toJSON {
        "SER/TKPWAL" = "Sergal";
        "SERLG" = "Sergal";
        "SER/WAL" = "serval";
      };
      onChange = "${pkgs.systemd}/bin/systemctl restart --user plover";
    };
  };
  systemd.user.services.plover = {
    Unit = {
      Description = "plover";
      After = [ "tray.target" ];
      PartOf = [ "graphical-session.target" ];
      Requires = [ "tray.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.plover.dev}/bin/plover";
    };
  };
}
