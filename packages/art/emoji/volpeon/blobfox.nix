{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "blobfox";
  manifest = ./emoji.json;
  configurePhase = ''
    rm a*.png
  '';
}
