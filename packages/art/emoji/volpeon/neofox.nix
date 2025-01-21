{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "neofox";
  manifest = ./emoji.json;
}
