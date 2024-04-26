{callPackage}:
callPackage ../../../lib/mkPleromaEmoji.nix {} rec {
  name = "vlpn";
  manifest = ./${name}.json;
  passthru.updateScript = [
    ../../../scripts/update-json.sh
    "https://volpeon.ink/emojis/${name}/manifest.json"
    "art/emoji/volpeon/${name}.json"
  ];
}
