{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "floof";
  manifest = ./emoji.json;
}
