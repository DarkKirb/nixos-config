{
  lib,
  pkgs,
  system,
  nix-packages,
  ...
}: let
  inherit (pkgs) plover plover-plugins-manager plover-plugin-emoji plover-plugin-tapey-tape plover-plugin-yaml-dictionary plover-plugin-rkb1-hid;
  plover-env = plover.pythonModule.withPackages (_: [plover plover-plugins-manager plover-plugin-emoji plover-plugin-tapey-tape plover-plugin-yaml-dictionary plover-plugin-rkb1-hid]);
  plover-src = plover.src;
  plover-dictionaries-english =
    [
      {
        enabled = true;
        path = "tmpdic.yaml";
      }
      {
        enabled = true;
        path = ../../extra/user.yaml;
      }
    ]
    ++ (map (module: {
        enabled = true;
        path = "${nix-packages.packages.${system}.plover-dict-didoesdigital}/dictionaries/${module}.json";
      }) [
        #Put this first
        "fingerspelling"
        # put these in alphabetical order
        "abbreviations"
        "briefs"
        "computer-use"
        "currency"
        "dict"
        "modifiers-single-stroke"
        "navigation"
        "nouns"
        "numbers"
        "numbers-powerups"
        "plover-use"
        "proper-nouns"
        "punctuation-powerups"
        "punctuation-unspaced"
        "punctuation"
        "symbols"
        "symbols-briefs"
        "symbols-currency"
        "tabbing"
        "top-level-domains"
        # Put these last
        "condensed-strokes"
      ]);
  plover-cfg = pkgs.writeText "plover.cfg" (lib.generators.toINI {} {
    "Machine Configuration".machine_type = "Plover HID";
    "System: English Stenotype" = {
      dictionaries = builtins.toJSON plover-dictionaries-english;
      "keymap[plover hid]" = ''[["#", ["X3", "X4", "X5", "X6", "X7", "X8", "X37", "X38", "X43", "X44", "X45", "X46", "X47", "X48", "X77", "X78"]], ["S-", ["X15", "X23"]], ["T-", ["X14"]], ["K-", ["X22"]], ["P-", ["X13"]], ["W-", ["X21"]], ["H-", ["X12"]], ["R-", ["X20"]], ["A-", ["X36"]], ["O-", ["X35"]], ["*", ["X11", "X19", "X56", "X64"]], ["-E", ["X80"]], ["-U", ["X79"]], ["-F", ["X55"]], ["-R", ["X63"]], ["-P", ["X54"]], ["-B", ["X62"]], ["-L", ["X53"]], ["-G", ["X61"]], ["-T", ["X52"]], ["-S", ["X60"]], ["-D", ["X51"]], ["-Z", ["X59"]], ["no-op", ["X1", "X2", "X9", "X10", "X16", "X17", "X18", "X24", "X25", "X26", "X27", "X28", "X29", "X30", "X31", "X32", "X33", "X34", "X39", "X40", "X41", "X42", "X49", "X50", "X57", "X58", "X65", "X66", "X67", "X68", "X69", "X70", "X71", "X72", "X73", "X74", "X75", "X76"]]]'';
    };
    Plugins.enabled_extensions = builtins.toJSON ["plover_tapey_tape"];
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
      ExecStart = "${plover-env}/bin/plover";
    };
  };
}
