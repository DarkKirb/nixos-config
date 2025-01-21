{ lib, pkgs, ... }:
let
  lock-script = pkgs.writeScriptBin "suspend" ''
    ${lib.getExe pkgs.swaylock} -f -c 000000
    ${lib.getExe pkgs.mpc-cli} pause
  '';
  screen-off-script = pkgs.writeScriptBin "screenOff" ''
    ${lib.getExe' pkgs.sway "swaymsg"} "output * dpms off"
  '';
  suspend-script = pkgs.writeScriptBin "suspend" ''
    ${lib.getExe' pkgs.systemd "systemctl"} suspend
  '';
  resume-script = pkgs.writeScriptBin "resume" ''
    ${lib.getExe' pkgs.sway "swaymsg"} "output * dpms on"
  '';
  unlock-script = pkgs.writeScriptBin "unlock" ''
    ${lib.getExe' pkgs.procps "pkill"} swaylock
    ${lib.getExe pkgs.mpc-cli} play
  '';
in
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${lib.getExe lock-script}";
      }
      {
        event = "lock";
        command = "${lib.getExe lock-script}";
      }
      {
        event = "unlock";
        command = "${lib.getExe unlock-script}";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${lib.getExe lock-script}";
      }
      {
        timeout = 305;
        command = "${lib.getExe screen-off-script}";
        resumeCommand = "${lib.getExe resume-script}";
      }
      {
        timeout = 900;
        command = "${lib.getExe suspend-script}";
      }
    ];
  };
}
