{plasma-manager, ...}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.plasma = true;

  imports = [
    ./i18n.nix
    plasma-manager.homeManagerModules.plasma-manager
    ./theming.nix
  ];
}
