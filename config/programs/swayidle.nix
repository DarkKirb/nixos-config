{pkgs, ...}: let
  lock-script = pkgs.writeScript "suspend" ''
    ${pkgs.swaylock}/bin/swaylock -f -c 000000
    ${pkgs.mpc-cli}/bin/mpc pause
  '';
  screen-off-script = pkgs.writeScript "screenOff" ''
    ${pkgs.sway}/bin/swaymsg "output * dpms off"
  '';
  suspend-script = pkgs.writeScript "suspend" ''
    ${pkgs.systemd}/bin/systemctl suspend
  '';
  resume-script = pkgs.writeScript "resume" ''
    ${pkgs.sway}/bin/swaymsg "output * dpms on"
  '';
  unlock-script = pkgs.writeScript "unlock" ''
    ${pkgs.procps}/bin/pkill swaylock
    ${pkgs.mpc-cli}/bin/mpc play
  '';
in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${lock-script}";
      }
      {
        event = "lock";
        command = "${lock-script}";
      }
      {
        event = "unlock";
        command = "${unlock-script}";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${lock-script}";
      }
      {
        timeout = 305;
        command = "${screen-off-script}";
        resume = "${resume-script}";
      }
      {
        timeout = 900;
        command = "${suspend-script}";
      }
    ];
  };
}
