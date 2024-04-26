{callPackage}:
callPackage ../../../lib/mkPleromaEmoji.nix {} rec {
  name = "blobfox";
  manifest = ./${name}.json;
  passthru.updateScript = [
    ../../../scripts/update-json.sh
    "https://volpeon.ink/emojis/${name}/manifest.json"
    "art/emoji/volpeon/${name}.json"
  ];
  configurePhase = ''
    rm a*.png
  '';
}
