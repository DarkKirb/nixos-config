{
  config,
  pkgs,
  lib,
  ...
}: let
  c = "$";
  switch_window = pkgs.writeScript "switchWindow" ''
    set -euo pipefail

    tree=$(${pkgs.sway}/bin/swaymsg -t get_tree)
    readarray -t win_ids <<< "$(${pkgs.jq}/bin/jq -r '.. | objects | select(has("app_id")) | .id' <<< "$tree")"
    readarray -t win_names <<< "$(${pkgs.jq}/bin/jq -r '.. | objects | select(has("app_id")) | .name' <<< "$tree")"
    readarray -t win_types <<< "$(${pkgs.jq}/bin/jq -r '.. | objects | select(has("app_id")) | .app_id // .window_properties.class' <<< "$tree")"

    switch () {
        local k
        read -r k
        swaymsg "[con_id=${c}{win_ids[$k]}] focus"
    }

    for k in $(seq 0 $((${c}{#win_ids[@]} - 1))); do
        echo -e "<span weight=\"bold\">${c}{win_types[$k]}</span> - ${c}{win_names[$k]}"
    done | rofi -dmenu -markup-rows -i -p window -format i | switch
  '';
  screenshot_then_switch = pkgs.writeScript "screenshotThenSwitch" ''
    ${pkgs.sway-contrib.grimshot}/bin/grimshot "$@"
    ${pkgs.sway}/bin/swaymsg mode default
  '';
  bg-full-res = "${pkgs.lotte-art}/2022-06-21-sammythetanuki-lotteplushpride.jxl";
  bg-1440p = pkgs.stdenvNoCC.mkDerivation {
    name = "wayland-background-1440p.png";
    nativeBuildInputs = [pkgs.imagemagick pkgs.libjxl];
    src = pkgs.emptyDirectory;
    buildPhase = ''
      djxl ${bg-full-res} bg-full-res.png
      convert bg-full-res.png -resize 2560x1440 $out
    '';
    installPhase = "true";
  };
  bg-1080p = pkgs.stdenvNoCC.mkDerivation {
    name = "wayland-background-1080p.png";
    nativeBuildInputs = [pkgs.imagemagick pkgs.libjxl];
    src = pkgs.emptyDirectory;
    buildPhase = ''
      djxl ${bg-full-res} bg-full-res.png
      convert bg-full-res.png -resize 1920x1080 $out
    '';
    installPhase = "true";
  };
in {
  imports = [
    ./wl-clipboard.nix
    ./mako.nix
    ./swayidle.nix
    ./foot.nix
    ./rofi.nix
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
        "eDP-1" = {
          bg = "${bg-1080p} fill";
        };
        "DP-1" = {
          mode = "2560x1440@74.971Hz";
          position = "0 0";
          subpixel = "rgb";
          adaptive_sync = "on";
          bg = "${bg-1440p} fill";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
          position = "2560 0";
          subpixel = "rgb";
          bg = "${bg-1080p} fill";
        };
      };
      keybindings = let
        inherit (config.wayland.windowManager.sway.config) modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
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
          Print = "exec ${screenshot_then_switch} copy area";
          "Shift+Print" = "exec ${screenshot_then_switch} save area $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          a = "exec ${screenshot_then_switch} copy active";
          "Shift+a" = "exec ${screenshot_then_switch} save active $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          s = "exec ${screenshot_then_switch} copy screen";
          "Shift+s" = "exec ${screenshot_then_switch} save screen $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          o = "exec ${screenshot_then_switch} copy output";
          "Shift+o" = "exec ${screenshot_then_switch} save output $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          w = "exec ${screenshot_then_switch} copy window";
          "Shift+w" = "exec ${screenshot_then_switch} save window $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          Escape = ''mode "default"'';
          Return = ''mode "default"'';
        };
      };
    };
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export QT_SCALE_FACTOR=1
      export GDK_SCALE=1
      export GDK_DPI_SCALE=1
      export MOZ_ENABLE_WAYLAND=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_QPA_PLATFORMTHEME=qt5ct
    '';
    extraConfig = ''
      default_border none
      gaps outer 8
      gaps inner 4
    '';
  };

  home.file.".XCompose".source = ../../extra/.XCompose;
}
