{ config, ... }:
{
  services.xserver.enable = !config.isSway;
  services.displayManager.sddm = {
    enable = !config.isSway;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };
  services.desktopManager.plasma6.enable = !config.isSway;

  imports = [
    ./i18n.nix
  ];

  home-manager.users.darkkirb.imports =
    if !config.isSway then
      [
        ./home-manager.nix
      ]
    else
      [ ];
}
