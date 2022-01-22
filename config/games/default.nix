{ pkgs, ... }:
let wine-tkg-patched = pkgs.nix-gaming.wine-tkg.override {
  patches = [
    (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NeonOverflow/wine-patches/master/roblox_mouse_fix.mypatch";
        sha256 = "0w4bpqypi6qags91slgfz0i7mz8zib5p5h7b1cwwzilss2hjixk9";
      }
    )
  ];
};
in
{
  home.packages = [
    wine-tkg-patched
    pkgs.grapejuice
    pkgs.polymc
    pkgs.factorio # downloaded from an internal cache server
  ];
}
