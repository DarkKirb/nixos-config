{
  config,
  pkgs,
  lib,
  ...
}: let
  switch_window = pkgs.writeScript "switchWindow" ''
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
    ${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r "$jq_filter" | ${pkgs.wofi}/bin/wofi -m --insensitive --show dmenu --prompt='Focus a window' | {
      read -r id name && swaymsg "[con_id=$id]" focus
    }
  '';
  screenshot_then_switch = pkgs.writeScript "screenshotThenSwitch" ''
    ${pkgs.sway-contrib.grimshot}/bin/grimshot "$@"
    ${pkgs.sway}/bin/swaymsg mode default
  '';
  bg-full-res = "${pkgs.lotte-art}/2022-06-21-sammythetanuki-lotteplushpride.jxl";
  bg-1440p = pkgs.stdenvNoCC.mkDerivation {
    name = "wayland-background-1440p.png";
    nativeBuildInputs = [pkgs.imagemagick];
    src = pkgs.emptyDirectory;
    buildPhase = ''
      convert ${bg-full-res} -resize 2560x1440 $out
    '';
    installPhase = "true";
  };
  bg-1080p = pkgs.stdenvNoCC.mkDerivation {
    name = "wayland-background-1080p.png";
    nativeBuildInputs = [pkgs.imagemagick];
    src = pkgs.emptyDirectory;
    buildPhase = ''
      convert ${bg-full-res} -resize 1920x1080 $out
    '';
    installPhase = "true";
  };
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      ${pkgs.systemd}/bin/systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      ${pkgs.systemd}/bin/systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        ${pkgs.glib}/bin/gsettings set $gnome_schema gtk-theme 'Breeze-Dark'
      '';
  };
in {
  imports = [
    ./wl-clipboard.nix
    ./mako.nix
    ./swayidle.nix
  ];
  home.file.".config/wofi/config".text = ''
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
          "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
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
          Print = "exec ${screenshot_then_switch} copy area";
          "Shift+Print" = "exec ${screenshot_then_switch} save area $HOME/Pictures/grim-$(date --iso=s).png";
          a = "exec ${screenshot_then_switch} copy active";
          "Shift+a" = "exec ${screenshot_then_switch} save active $HOME/Pictures/grim-$(date --iso=s).png";
          s = "exec ${screenshot_then_switch} copy screen";
          "Shift+s" = "exec ${screenshot_then_switch} save screen $HOME/Pictures/grim-$(date --iso=s).png";
          o = "exec ${screenshot_then_switch} copy output";
          "Shift+o" = "exec ${screenshot_then_switch} save output $HOME/Pictures/grim-$(date --iso=s).png";
          w = "exec ${screenshot_then_switch} copy window";
          "Shift+w" = "exec ${screenshot_then_switch} save window $HOME/Pictures/grim-$(date --iso=s).png";
          Escape = ''mode "default"'';
          Return = ''mode "default"'';
        };
      };
    };
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1 
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=sway
    '';
    extraConfig = ''
      exec ${dbus-sway-environment}/bin/dbus-sway-environment
      exec ${configure-gtk}/bin/configure-gtk
      exec ${pkgs.systemd}/bin/systemctl --user import-environment
    '';
  };

  #home.file.".XCompose".source = ../../extra/.XCompose;
}
