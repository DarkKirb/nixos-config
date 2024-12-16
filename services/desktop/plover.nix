{
  pkgs,
  lib,
  ...
}:
let
  plover-cfg = pkgs.writeText "plover.cfg" (
    lib.generators.toINI { } {
      "Output Configuration".undo_levels = 100;
      "Logging Configuration".log_file = "strokes.log";
      "Translation Frame".opacity = 100;
      Plugins.enabled_extensions = ''["RKB Unicode Sender", "modal_update", "plover_dotool_output"]'';
      System.name = "Lapwing";
      "Machine Configuration" = {
        auto_start = "True";
        machine_type = "TX Bolt";
      };
      "TX Bolt" = {
        baudrate = 8;
        bytesize = 8;
        parity = "N";
        port = "/dev/serial/by-id/usb-Charlotte_🦝_Delenk_rkb1-if03";
        stopbits = 1;
        timeout = 2.0;
      };
    }
  );
  plover = pkgs.writeScriptBin "plover" ''
    #!/bin/sh
    exec ${pkgs.plover-env}/bin/plover "$@"
  '';
  plover_plugins = pkgs.writeScriptBin "plover_plugins" ''
    #!/bin/sh
    exec ${pkgs.plover-env}/bin/plover_plugins "$@"
  '';
  plover_send_command = pkgs.writeScriptBin "plover_send_command" ''
    #!/bin/sh
    exec ${pkgs.plover-env}/bin/plover_send_command "$@"
  '';
in
{
  home.packages = [
    plover
    plover_plugins
    plover_send_command
    pkgs.dotool
  ];
  home.activation.ploverSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir $VERBOSE_ARG -p $HOME/.config/plover
    run rm -f $VERBOSE_ARG $HOME/.config/plover/plover.cfg
    run cp $VERBOSE_ARG ${plover-cfg} $HOME/.config/plover/plover.cfg
    run chmod +w $VERBOSE_ARG $HOME/.config/plover/plover.cfg
  '';
}
