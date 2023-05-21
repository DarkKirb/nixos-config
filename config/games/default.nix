args: {
  pkgs,
  nixpkgs,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  home.packages = [
    x86_64-linux-pkgs.wineWowPackages.staging
    pkgs.prismlauncher
  ];
}
