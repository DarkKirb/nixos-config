{
  system,
  config,
  pkgs,
  lib,
  ...
}: {
  programs.sway.enable = true;
  programs.sway.package = config.home-manager.users.darkkirb.wayland.windowManager.sway.package;
  security.pam.services.sddm.u2fAuth = true;
  services.xserver = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
}
