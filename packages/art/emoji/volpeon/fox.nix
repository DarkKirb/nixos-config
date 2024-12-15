{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "fox";
  manifest = ./emoji.json;
}
