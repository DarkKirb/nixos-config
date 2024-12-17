{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "drgn";
  manifest = ./emoji.json;
}
