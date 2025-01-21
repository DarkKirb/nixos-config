{
  pkgs,
  lib,
  ...
}:
let
  dictionaries = [
    {
      enabled = true;
      path = pkgs.writeText "user.json" (
        builtins.toJSON {
          "SROR" = "vore";
          "SROR/KWREU" = "vorny";
        }
      );
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/abby-left-hand-modifiers.py";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/emily-modifiers.py";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/jeff-phrasing.py";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-base.json";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-commands.json";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-movement.modal";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-numbers.json";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-proper-nouns.json";
    }
    {
      enabled = true;
      path = "${pkgs.plover_lapwing_aio.src}/plover_lapwing/dictionaries/lapwing-uk-additions.json";
    }
  ];
  plover-cfg = pkgs.writeText "plover.cfg" (
    lib.generators.toINI { } {
      "Output Configuration".undo_levels = 100;
      "Logging Configuration".log_file = "strokes.log";
      "Translation Frame".opacity = 100;
      Plugins.enabled_extensions = ''["modal_update", "plover_uinput"]'';
      System.name = "Lapwing";
      "System: Lapwing".dictionaries = builtins.toJSON dictionaries;
      "Machine Configuration" = {
        auto_start = "True";
        machine_type = "Gemini PR";
      };
      "Gemini PR" = {
        baudrate = 1000000;
        bytesize = 8;
        parity = "N";
        port = "/dev/serial/by-id/usb-Charlotte_🦝_Delenk_rkb1-if03";
        stopbits = 1;
        timeout = 2.0;
      };
    }
  );
  plover = pkgs.writeScriptBin "plover" ''
    #!${lib.getExe pkgs.bash}
    exec ${lib.getExe' pkgs.plover-env "plover"} "$@"
  '';
  plover_plugins = pkgs.writeScriptBin "plover_plugins" ''
    #!${lib.getExe pkgs.bash}
    exec ${lib.getExe' pkgs.plover-env "plover_plugins"} "$@"
  '';
  plover_send_command = pkgs.writeScriptBin "plover_send_command" ''
    #!${lib.getExe pkgs.bash}
    exec ${lib.getExe' pkgs.plover-env "plover_send_command"} "$@"
  '';
in
{
  home.packages = [
    plover
    plover_plugins
    plover_send_command
  ];
  home.activation.ploverSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir $VERBOSE_ARG -p $HOME/.config/plover
    run rm -f $VERBOSE_ARG $HOME/.config/plover/plover.cfg
    run cp $VERBOSE_ARG ${plover-cfg} $HOME/.config/plover/plover.cfg
    run chmod +w $VERBOSE_ARG $HOME/.config/plover/plover.cfg
  '';
  xdg.desktopEntries.plover = {
    name = "Plover";
    exec = "${lib.getExe' pkgs.plover-env "plover"}";
    icon = "${pkgs.plover.src}/plover/gui_qt/resources/plover.png";
    categories = [
      "Utility"
      "Accessibility"
    ];
    comment = "stenographic input and translation";
  };
}
