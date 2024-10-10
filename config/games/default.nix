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
        (pkgs.wineWowPackages.stagingFull.override {waylandSupport = true;})
      ]
      else []
    );
}
