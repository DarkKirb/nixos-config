{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      main_bar = {
        spacing = 4;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          #          "sway/language"
          "battery"
          "battery#bat2"
          "clock"
          "tray"
        ];
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
        };
        "sway/mode" = {
          format = "{}";
        };
        mpd = {
          format = "{stateIcon} {artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          format-disconnected = "ﳌ";
          format-stopped = "";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "${pkgs.mpc}/bin/mpc toggle";
          on-click-middle = "${pkgs.foot}/bin/foot ${pkgs.ncmpcpp}/bin/ncmpcpp";
          on-click-right = "${pkgs.mpc}/bin/mpc stop";
          on-scroll-up = "${pkgs.mpc}/bin/seekthrough +00:00:10";
          on-scroll-down = "${pkgs.mpc}/bin/seekthrough -00:00:10";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%Y-%m-%dT%H:%M:%S+01:00}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}℃ {icon}";
          format-icons = ["" "" ""];
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["" ""];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        network = {
          format-wifi = " {essid} {ipaddr}";
          format-ethernet = " {ipaddr}";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };
  };
}
