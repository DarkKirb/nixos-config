args: {
  pkgs,
  nixpkgs,
  nix-gaming,
  ...
}: {
  home.packages = [
    nix-gaming.packages.x86_64-linux.wine-ge
    pkgs.xivlauncher
    pkgs.prismlauncher
    pkgs.mgba
  ];
}
