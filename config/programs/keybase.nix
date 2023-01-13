{nixpkgs, ...}: let
  x86_64-linux-pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  services.keybase.enable = true;
  services.kbfs.enable = true;
  home.packages = [
    x86_64-linux-pkgs.keybase-gui
  ];
}
