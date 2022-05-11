{ pkgs, ... }: {
  imports = [
    ./ibus.nix
  ];
  home.packages = with pkgs; [
    kde-gtk-config
  ];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  home.file.".face.icon".source = ../../extra/.face.icon;
}
