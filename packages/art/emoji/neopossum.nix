{ callPackage }:
callPackage ./lib/mkPleromaEmoji.nix { } rec {
  name = "neopossum";
  manifest = ./${name}.json;
  subdir = "256px";
}
