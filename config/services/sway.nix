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
      xwayland
      wl-clipboard
      (python38.withPackages (ps: with ps; [ i3pystatus keyring ]))
    ];
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
