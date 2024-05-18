{callPackage}:
callPackage ../../lib/mkPleromaEmoji.nix {} rec {
  name = "raccoon";
  manifest = ./${name}.json;
}
