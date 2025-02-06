{
  pkgs,
  lib,
  config,
  system,
  ...
}:
let
  sway = config.wayland.windowManager.sway.package;
  screenshot_then_switch = pkgs.writeScriptBin "screenshotThenSwitch" ''
    ${lib.getExe pkgs.sway-contrib.grimshot} "$@"
    ${lib.getExe' sway "swaymsg"} mode default
  '';
  mkKeybind = combo: number: [
    {
      name = "Mod4+${combo}";
      value = "workspace number ${toString number}";
    }
    {
      name = "Mod4+Shift+${combo}";
      value = "move container to workspace number ${toString number}";
    }
  ];
  keys = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "f1"
    "f2"
    "f3"
    "f4"
    "f5"
    "f6"
    "f7"
    "f8"
    "f9"
    "f10"
    "f11"
    "f12"
  ];
  combos = lib.concatMap (k: map (s: "${k}${s}") keys) [
    ""
    "ctrl+"
    "alt+"
    "ctrl+alt+"
  ];
  keybinds = lib.flatten (
    lib.zipListsWith mkKeybind combos (lib.lists.range 0 ((lib.lists.length combos) - 1))
  );

in
{
  programs.fish.loginShellInit = ''
    if not set -q DISPLAY
    and test (tty) = /dev/tty1
      exec ${lib.getExe sway}
    end
  '';

  imports = [
    ./cliphist.nix
    ./mako.nix
    ./swayidle.nix
    ./rofi.nix
    ./mpd.nix
    ./waybar.nix
  ];
  programs.alacritty.enable = true;
  wayland.windowManager.sway = {
    systemd.enable = true;
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${lib.getExe pkgs.alacritty}";
      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "neo";
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
        "DSI-1" = {
          transform = "90";
        };
      };
      keybindings =
        let
          inherit (config.wayland.windowManager.sway.config) modifier;
        in
        lib.mkOptionDefault (
          {
            "${modifier}+d" = "exec ${lib.getExe pkgs.rofi} -show drun";
            "Print" = "mode screenshot";
            "XF86AudioRaiseVolume" =
              "exec ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" =
              "exec ${lib.getExe' pkgs.pulseaudio "pactl"} set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
            "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set +5%";
            "XF86AudioPlay" = "exec ${lib.getExe pkgs.mpc-cli} toggle";
            "XF86AudioNext" = "exec ${lib.getExe pkgs.mpc-cli} next";
            "XF86AudioPrev" = "exec ${lib.getExe pkgs.mpc-cli} prev";
            "XF86AudioStop" = "exec ${lib.getExe pkgs.mpc-cli} stop";
          }
          // (lib.listToAttrs keybinds)
        );
      bars = [
        {
          command = "${lib.getExe pkgs.waybar}";
        }
      ];
      modes = {
        screenshot = {
          Print = "exec ${lib.getExe screenshot_then_switch} copy area";
          "Shift+Print" =
            "exec ${lib.getExe screenshot_then_switch} save area $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          a = "exec ${lib.getExe screenshot_then_switch} copy active";
          "Shift+a" =
            "exec ${lib.getExe screenshot_then_switch} save active $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          s = "exec ${lib.getExe screenshot_then_switch} copy screen";
          "Shift+s" =
            "exec ${lib.getExe screenshot_then_switch} save screen $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          o = "exec ${lib.getExe screenshot_then_switch} copy output";
          "Shift+o" =
            "exec ${lib.getExe screenshot_then_switch} save output $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          w = "exec ${lib.getExe screenshot_then_switch} copy window";
          "Shift+w" =
            "exec ${lib.getExe screenshot_then_switch} save window $HOME/Pictures/grim-$(date --iso=s | sed 's/:/-/g').png";
          Escape = ''mode "default"'';
          Return = ''mode "default"'';
        };
      };
    };
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands =
      ''
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=0
        export QT_SCALE_FACTOR=1
        export GDK_SCALE=1
        export GDK_DPI_SCALE=1
        export MOZ_ENABLE_WAYLAND=1
        export _JAVA_AWT_WM_NONREPARENTING=1
      ''
      + (
        if system == "x86_64-linux" then
          ''
            export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json
          ''
        else
          ""
      );
    extraConfig = ''
      default_border none
      gaps outer 8
      gaps inner 4
      exec_always ${lib.getExe pkgs.xorg.xrandr} --output DP-1 --primary
      exec ${lib.getExe (pkgs.python3.withPackages (ps: [ps.i3ipc]))} ${./transparency.py}
    '';
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
