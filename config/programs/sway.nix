{ ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "*" = {
          xkb_layout = "de,de";
          xkb_variant = "neo_qwertz,neo";
          xkb_options = "ctrls_toggle";
        };
      };
    };
  };
}