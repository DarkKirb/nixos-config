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
  echo "kodi-pydes: Checking for updates"
  CURRENT_COMMIT=$(${curl}/bin/curl https://api.github.com/repos/twhiteman/pyDes/commits | ${jq}/bin/jq -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "kodi-pydes: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://github.com/twhiteman/pyDes | ${jq}/bin/jq > packages/kodi/pydes/source.json
  fi
  echo "kodi-pydes: Done"
''
