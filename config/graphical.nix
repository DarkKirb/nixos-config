{
  nixos-config,
  config,
  pkgs,
  lib,
  ...
}:
{
  time.timeZone = "Etc/GMT-1";
  isGraphical = true;
  imports = [
    ./kde
    ./documentation.nix
    ./graphical/fonts.nix
    "${nixos-config}/services/security-key"
  ];
  home-manager.users.darkkirb.imports =
    if config.isSway then
      [
        ./sway
        ./graphical/gtk-fixes
      ]
    else
      [ ./graphical/gtk-fixes ];
  xdg.portal = {
    wlr.enable = config.isSway;
    extraPortals =
      with pkgs;
      (lib.mkIf config.isSway [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
      ]);
    config.common.default = lib.mkIf config.isSway "wlr";
  };
  security.pam.services.swaylock = { };
}
