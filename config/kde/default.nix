{ config, ... }:
{
  services.desktopManager.plasma6.enable = (config.system.wm == "kde");

  imports = [
    ./i18n.nix
  ];

  home-manager.users.darkkirb.imports =
    if (config.system.wm == "kde") then
      [
        ./home-manager.nix
      ]
    else
      [ ];
}
