{pkgs, ...}: {
  imports = [
    ./firefox
    ./password-manager.nix
    ./syncthing
    ./games
    ./ims.nix
    ./audacious.nix
  ];
  home.packages = with pkgs; [
    kdePackages.kontact
  ];
}
