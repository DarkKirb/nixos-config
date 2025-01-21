{ lib, curl }:
''
  echo "volpeon-emoji: Updating"
  ${lib.getExe curl} https://volpeon.ink/emojis/pleroma.json > packages/art/emoji/volpeon/emoji.json
  echo "volpeon-emoji: Done"
''
