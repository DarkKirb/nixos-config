{
  config,
  pkgs,
  lib,
  ...
}:
{
  time.timeZone = "Etc/GMT-1";
  system.isGraphical = true;
  imports = [
    ./kde
    ./documentation.nix
    ./graphical/fonts.nix
    ../services/security-key
  ];
  home-manager.users.darkkirb.imports =
    if (config.system.wm == "sway") then
      [
        ./sway
        ./graphical/gtk-fixes
      ]
    else
      [ ./graphical/gtk-fixes ];
  xdg.portal = {
    wlr.enable = (config.system.wm == "sway");
    extraPortals =
      with pkgs;
      (lib.mkIf (config.system.wm == "sway") [
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
      ]);
    config.common.default = lib.mkIf (config.system.wm == "sway") "wlr";
  };
  security.pam.services.swaylock = { };
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = if (config.system.wm == "sway") then "weston" else "kwin";
  };
  programs.sway.enable = (config.system.wm == "sway");
}
