{ pkgs, ... }:
let
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
in
{
  systemd.user.services.swayidle = {
    Unit = {
      Description = "swayidle";
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 ${lock-script} timeout 305 ${screen-off-script} resume ${resume-script} before-sleep ${lock-script} lock ${lock-script} unlock ${unlock-script}";
    };
  };
}
