{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "bunhd";
  manifest = ./emoji.json;
  configurePhase = ''
    rm a*.png
  '';
}
