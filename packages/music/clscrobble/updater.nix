{
  nix-prefetch-git,
  go-updater,
  curl,
  jq,
  lib,
}:
let
  srcInfo = lib.importJSON ./source.json;
in
''
  echo "clscrobble: Checking for updates"
  CURRENT_COMMIT=$(${lib.getExe curl} https://codeberg.org/api/v1/repos/punkscience/clscrobble/commits | ${lib.getExe jq} -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "clscrobble: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${lib.getExe' nix-prefetch-git "nix-prefetch-git"} https://codeberg.org/punkscience/clscrobble.git | ${lib.getExe jq} > packages/music/clscrobble/source.json
    NEW_PATH=$(cat packages/music/clscrobble/source.json | ${lib.getExe jq} -r .path)
    ${go-updater {
      sourcePath = "$NEW_PATH";
      targetDir = "packages/music/clscrobble";
    }}
  fi
  echo "clscrobble: Done"
''
