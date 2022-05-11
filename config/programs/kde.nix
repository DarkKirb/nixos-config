{ pkgs, ... }: {
  imports = [
    ./ibus.nix
  ];
  home.packages = with pkgs; [
    kde-gtk-config
    kdeconnect
  ];
}
