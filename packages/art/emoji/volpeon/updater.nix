{
  lib,
  jq,
  curl,
}:
''
  echo "volpeon-emoji: Updating"
  ${lib.getExe curl} https://volpeon.ink/emojis/pleroma.json | $[lib.getExe pkgs.jq} -S > packages/art/emoji/volpeon/emoji.json
  echo "volpeon-emoji: Done"
''
