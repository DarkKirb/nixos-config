{
  pkgs,
  config,
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
        machine_type = "Plover HID";
      };
      "System: Lapwing"."keymap[plover hid]" =
        ''[["#", ["X3", "X4", "X5", "X6", "X7", "X8", "X15", "X43", "X44", "X45", "X46", "X47", "X48"]], ["S-", ["X23"]], ["T-", ["X14"]], ["K-", ["X22"]], ["P-", ["X13"]], ["W-", ["X21"]], ["H-", ["X12"]], ["R-", ["X20"]], ["A-", ["X36"]], ["O-", ["X35"]], ["*", ["X11", "X19", "X56", "X64"]], ["-E", ["X80"]], ["-U", ["X79"]], ["-F", ["X55"]], ["-R", ["X63"]], ["-P", ["X54"]], ["-B", ["X62"]], ["-L", ["X53"]], ["-G", ["X61"]], ["-T", ["X52"]], ["-S", ["X60"]], ["-D", ["X51"]], ["-Z", ["X59"]], ["no-op", ["X1", "X2", "X9", "X10", "X17", "X18", "X25", "X26", "X27", "X28", "X29", "X30", "X31", "X32", "X33", "X34", "X39", "X40", "X41", "X42", "X49", "X50", "X57", "X58", "X65", "X66", "X67", "X68", "X69", "X70", "X71", "X72", "X73", "X74", "X75", "X76"]]]'';
    }
  );
in
{
  home.packages = [ pkgs.plover-env ];
  home.activation.ploverSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir $VERBOSE_ARG -p $HOME/.config/plover
    run rm -f $VERBOSE_ARG $HOME/.config/plover/plover.cfg
    run cp $VERBOSE_ARG ${plover-cfg} $HOME/.config/plover/plover.cfg
    run chmod +w $VERBOSE_ARG $HOME/.config/plover/plover.cfg
  '';
}
