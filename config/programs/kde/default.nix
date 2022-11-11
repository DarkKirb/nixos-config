{plasma-manager, ...}: {
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
    ./kdeconnect.nix
    ./dump.nix
  ];
}
