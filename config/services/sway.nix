{ config, pkgs, lib, ... }:
{
  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
      mako
      grim
      slurp
      wl-clipboard
      wf-recorder
      (python38.withPackages (ps: with ps; [ i3pystatus keyring ]))
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "sway";
    displayManager.sddm.enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
  };
}
