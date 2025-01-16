{
  pkgs,
  lib,
  systemConfig,
  ...
}:
{
  home.stateVersion = "24.11";
  home.activation.notify-services = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    run ${lib.getExe' pkgs.systemd "systemctl"} restart --user home-manager-activation || true
  '';
  systemd.user.services.home-manager-activation = {
    Unit = {
      Description = "Home manager activation";
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${lib.getExe' pkgs.coreutils "true"}";
    };
    Install.WantedBy = [ "basic.target" ];
  };
  home.persistence.default.enable = systemConfig.environment.impermanence.enable;
}
