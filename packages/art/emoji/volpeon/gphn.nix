{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "gphn";
  manifest = ./emoji.json;
}
