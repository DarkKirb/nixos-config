{plasma-manager, ...}: {
  programs.plasma.enable = true;
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
    ./theming.nix
  ];
}
