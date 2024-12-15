{ pkgs, lib, ... }:
{
  home.stateVersion = "24.11";
  home.activation.notify-services = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    run ${pkgs.systemd}/bin/systemctl restart --user home-manager-activation
  '';
  systemd.user.services.home-manager-activation = {
    Unit = {
      Description = "Home manager activation";
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
    Install.WantedBy = [ "basic.target" ];
  };
}
