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
  dconf.settings = {
    "desktop/ibus/general" = {
      engines-order = [ "xkb:de:neo:deu" "mozc-jp" ];
      preload-engines = [ "xkb:de:neo:deu" "mozc-jp" ];
      use-system-keyboard-layout = true;
      version = "1.5.26";
    };
    "desktop/ibus/panel" = {
      show = 0;
      use-glyph-from-engine-lang = true;
    };
    "desktop/ibus/emoji" = {
      hotkey = [ "<Control><Shift>e" ];
    };
  };
}
