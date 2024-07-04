args: {
  pkgs,
  nixpkgs,
  nix-gaming,
  system,
  ...
}: let
in {
  home.packages =
    [
      pkgs.prismlauncher
      pkgs.mgba
    ]
    ++ (
      if system == "x86_64-linux"
      then [
        pkgs.xivlauncher
        nix-gaming.packages.x86_64-linux.osu-lazer-bin
        pkgs.wineWowPackages.stagingFull
      ]
      else []
    );
}
