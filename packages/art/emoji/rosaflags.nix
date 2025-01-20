{ callPackage }:
callPackage ./lib/mkPleromaEmoji.nix { } rec {
  name = "rosaflags";
  manifest = ./${name}.json;
}
