{ config, pkgs, lib, ... }: {
  imports = [
    ./wl-clipboard.nix
    ./mako.nix
  ];
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
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show drun";
          "Print" = "mode screenshot";
        };
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
      modes = {
        screenshot = {
          Print = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
          w = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
          f = ''exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy'';
          Escape = ''mode "default"'';
          Return = ''mode "default"'';
        };
      };
      startup = [
        {
          command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f -c 000000' timeout 305 '${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' lock '${pkgs.swaylock}/bin/swaylock -f -c 000000' unlock '${pkgs.procps}/bin/pkill swaylock'";
        }
        {
          command = "${pkgs.plover.dev}/bin/plover";
        }
      ];
    };
    wrapperFeatures.gtk = true;
  };

  home.file.".XCompose ".source = ../../extra/.XCompose;
}



