{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "wvrn";
  manifest = ./emoji.json;
}
