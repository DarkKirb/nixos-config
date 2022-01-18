{ ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      input = {
        "*" = {
          xkb_layout = "de,de";
          xkb_variant = "neo_qwertz,neo";
          xkb_options = "grp:ctrls_toggle";
        };
      };
    };
  };
}