{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "neocat";
  manifest = ./emoji.json;
}
