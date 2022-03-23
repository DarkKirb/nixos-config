{ config, pkgs, lib, ... }:
let switch_window = pkgs.writeScript "switchWindow" ''
  # https://www.reddit.com/r/swaywm/comments/krd0sq/comment/gib6z73/?context=3
jq_filter='
    # descend to workspace or scratchpad
    .nodes[].nodes[]
    # save workspace name as .w
    | {"w": .name} + (
      if (.nodes|length) > 0 then # workspace
        [recurse(.nodes[])]
      else # scratchpad
        []
      end
      + .floating_nodes
      | .[]
      # select nodes with no children (windows)
      | select(.nodes==[])
    )
    | [
      "<span size=\"xx-small\">\(.id)</span>",
      # remove markup and index from workspace name, replace scratch with "[S]"
      "<span size=\"xx-small\">\(.w | gsub("^[^:]*:|<[^>]*>"; "") | sub("__i3_scratch"; "[S]"))</span>",
      # get app name (or window class if xwayland)
      "<span weight=\"bold\">\(if .app_id == null then .window_properties.class else .app_id end)</span>",
      "<span style=\"italic\">\(.name)</span>"
    ] | @tsv
'
${pkgs.sway}/bin/swaymsg -t get_tree | jq -r "$jq_filter" | ${pkgs.wofi} -m --insensitive --show dmenu --prompt='Focus a window' | {
  read -r id name && swaymsg "[con_id=$id]" focus
}
'';
in
{
  imports = [
    ./wl-clipboard.nix
    ./mako.nix
    ./swayidle.nix
    ./ibus.nix
  ];
  home.file.".config/wofi/config".content = ''
    allow_markup = true
    dmenu-parse_action = true
  '';
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
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          "XF86AudioPlay" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          "XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";
          "XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          "XF86AudioStop" = "exec ${pkgs.mpc-cli}/bin/mpc stop";
          "Mod1+Tab" = "exec ${switch_window}";
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
    };
    wrapperFeatures.gtk = true;
  };

  home.file.".XCompose".source = ../../extra/.XCompose;
}
