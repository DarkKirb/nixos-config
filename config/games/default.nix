args: {
  pkgs,
  nixpkgs,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  imports = [
    (import ./grapejuice.nix args)
  ];
  home.packages = [
    x86_64-linux-pkgs.wineWowPackages.staging
    pkgs.prismlauncher
  ];
}
