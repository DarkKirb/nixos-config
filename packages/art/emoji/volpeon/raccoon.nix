{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "raccoon";
  manifest = ./emoji.json;
}
