args: {
  pkgs,
  nixpkgs,
  nix-gaming,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  nixpkgs.overlays = [ nix-gaming.overlays.default ];
  home.packages = [
    pkgs.wine-ge
    pkgs.xivlauncher
    pkgs.prismlauncher
    pkgs.mgba
  ];
}
