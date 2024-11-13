{
  nix-prefetch-git,
  curl,
  jq,
  lib,
}:
let
  srcInfo = lib.importJSON ./source.json;
in
''
  echo "kodi-joyn: Checking for updates"
  CURRENT_COMMIT=$(${curl}/bin/curl https://api.github.com/repos/Maven85/plugin.video.joyn/commits | ${jq}/bin/jq -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "kodi-joyn: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://github.com/Maven85/plugin.video.joyn | ${jq}/bin/jq > packages/kodi/joyn/source.json
  fi
  echo "kodi-joyn: Done"
''
