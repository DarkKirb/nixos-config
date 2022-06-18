{
  lib,
  pkgs,
  system,
  ...
}: let
  inherit (pkgs) plover plover-plugins-manager regenpfeifer plover-regenpfeifer;
  plover-env = plover.pythonModule.withPackages (_: [plover plover-plugins-manager plover-regenpfeifer]);
  plover-src = plover.src;
  plover-dictionaries = [
    {
      enabled = true;
      path = pkgs.writeText "user.json" (builtins.toJSON {
        "SER/TKPWAL" = "Sergal";
        "SERLG" = "Sergal";
        "SER/SRAL" = "serval";
      });
    }
    {
      enabled = true;
      path = "${plover-src}/plover/assets/commands.json";
    }
    {
      enabled = true;
      path = "${plover-src}/plover/assets/main.json";
    }
  ];
  keyboard-keymap = [
    ["#" ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "-" "=" "b"]]
    ["S-" ["q" "a"]]
    ["T-" ["w"]]
    ["K-" ["s"]]
    ["P-" ["e"]]
    ["W-" ["d"]]
    ["H-" ["r"]]
    ["R-" ["f"]]
    ["A-" ["c"]]
    ["O-" ["v"]]
    ["*" ["t" "y" "g" "h"]]
    ["-E" ["n"]]
    ["-U" ["m"]]
    ["-F" ["u"]]
    ["-R" ["j"]]
    ["-P" ["i"]]
    ["-B" ["k"]]
    ["-L" ["o"]]
    ["-G" ["l"]]
    ["-T" ["p"]]
    ["-S" [";"]]
    ["-D" ["["]]
    ["-Z" ["'"]]
    ["arpeggiate" ["space"]]
    ["no-op" ["\\" "]" "z" "x" "" "." "/"]]
  ];
  plover-cfg = pkgs.writeText "plover.cfg" (lib.generators.toINI {} {
    "Machine Configuration".machine_type = "Keyboard";
    "System: English Stenotype" = {
      dictionaries = builtins.toJSON plover-dictionaries;
      "keymap[keyboard]" = builtins.toJSON keyboard-keymap;
    };
  });
in {
  home.packages = [
    plover-env
  ];
  home.activation.ploverSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir $VERBOSE_ARG -p $HOME/.config/plover
    $DRY_RUN_CMD rm -f $HOME/.config/plover/plover.cfg
    $DRY_RUN_CMD cp $VERBOSE_ARG ${plover-cfg} $HOME/.config/plover/plover.cfg
    $DRY_RUN_CMD chmod +w $VERBOSE_ARG $HOME/.config/plover/plover.cfg
  '';
  systemd.user.services.plover = {
    Unit = {
      Description = "plover";
      After = ["tray.target"];
      PartOf = ["graphical-session.target"];
      Requires = ["tray.target"];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${plover}/bin/plover";
    };
  };
}
