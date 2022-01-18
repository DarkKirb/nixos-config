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
      output = {
        "DP-1" = {
          mode = "2560x1440@74.971Hz";
          position = "0 0";
          subpixel = "rgb";
          adaptive_sync = "on";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
          position = "2560 0";
          subpixel = "rgb";
        };
      };
    };
  };
}
