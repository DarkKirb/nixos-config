{pkgs, nixos-config, ...}: {
  imports = [
    ./firefox
    ./password-manager.nix
    ./syncthing
    ./games
    ./ims.nix
    ./audacious.nix
    "${nixos-config}/services/desktop"
  ];
  home.packages = with pkgs; [
    kdePackages.kontact
  ];

}
