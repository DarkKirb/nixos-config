{nixpkgs, ...}: let
  x86_64-linux-pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  home.packages = [x86_64-linux-pkgs.zoom-us];
}
