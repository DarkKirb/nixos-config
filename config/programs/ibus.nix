{ pkgs, ... }:
let
  ibusPackage = pkgs.ibus-with-plugins.override {
    plugins = with pkgs.ibus-engines; [
      mozc
      table
      table-others
      uniemoji
    ];
  };
in
{
  systemd.user.services.ibus = {
    Unit = {
      Description = "IBus daemon";
      PartOf = [ "graphical-session.target" ];
      Requires = [ "dbus.socket" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${ibusPackage}/bin/ibus-daemon --xim";
    };
  };
}
