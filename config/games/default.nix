args: {
  pkgs,
  nixpkgs,
  nix-gaming,
  ...
}: {
  home.packages = [
    pkgs.xivlauncher
    pkgs.prismlauncher
    pkgs.mgba
  ];
}
