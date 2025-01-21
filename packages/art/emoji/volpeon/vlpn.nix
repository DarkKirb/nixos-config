{ callPackage }:
callPackage ../lib/mkPleromaEmoji.nix { } {
  name = "vlpn";
  manifest = ./emoji.json;
}
