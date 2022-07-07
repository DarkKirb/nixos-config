{
  lib,
  pkgs,
  system,
  nix-packages,
  ...
}: let
  inherit (pkgs) plover plover-plugins-manager regenpfeifer plover-regenpfeifer plover-emoji plover-tapey-tape plover-yaml-dictionary;
  plover-env = plover.pythonModule.withPackages (_: [plover plover-plugins-manager plover-emoji plover-tapey-tape plover-yaml-dictionary]);
  plover-src = plover.src;
  plover-dictionaries-english =
    [
      {
        enabled = true;
        path = pkgs.writeText "user.json" (builtins.toJSON {
          "SER/TKPWAL" = "Sergal";
          "SERLG" = "Sergal";
          "SER/SRAL" = "serval";
          "SOL/TKER" = "solder";
          "KWREUF" = "yiff";
          "KWR*EUF" = "I didn't have";
          "PWA/TPHA/TPHAS" = "bananas";
          "PWA/TPHA/TPHAZ" = "bananas";
          "HROT/TE" = "Lotte";
          "TPUR/SO/TPHA" = "fursona";
          "TPWH" = "to be honest";
          "TPWH*" = "tbh";
          "PWRU" = "bruh";
        });
      }
    ]
    ++ (map (module: {
        enabled = true;
        path = nix-packages.packages.${system}."plover-dict-${module}";
      }) [
        "abbreviations"
        "briefs"
        "computer-use"
        "currency"
        "dict"
        "fingerspelling"
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
        "top-10000-project-gutenberg-words"
        "top-level-domains"
        # Put these last
        "condensed-strokes"
        "condensed-strokes-fingerspelled"
      ]);
  plover-cfg = pkgs.writeText "plover.cfg" (lib.generators.toINI {} {
    "Machine Configuration".machine_type = "Keyboard";
    "System: English Stenotype" = {
      dictionaries = builtins.toJSON plover-dictionaries-english;
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
