{
  lib,
  pkgs,
  system,
  nix-packages,
  ...
}: let
  inherit (pkgs) plover plover-plugins-manager plover-emoji plover-tapey-tape plover-yaml-dictionary plover-machine-hid;
  plover-env = plover.pythonModule.withPackages (_: [plover plover-plugins-manager plover-emoji plover-tapey-tape plover-yaml-dictionary plover-machine-hid]);
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
        path = nix-packages.packages.${system}."plover-dict-${module}";
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
