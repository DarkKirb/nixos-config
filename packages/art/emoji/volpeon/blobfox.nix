{ callPackage }:
callPackage ../../../lib/mkPleromaEmoji.nix { } {
  name = "blobfox";
  manifest = ./emoji.json;
  passthru.updateScript = [
    ../../../scripts/update-json.sh
    "https://volpeon.ink/emojis/pleroma.json"
    "art/emoji/volpeon/emoji.json"
  ];
  configurePhase = ''
    rm a*.png
  '';
}
