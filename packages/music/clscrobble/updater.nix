{
  nix-prefetch-git,
  gomod2nix,
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
    NEW_PATH=$(cat packages/music/clscrobble/source.json | jq -r .path)
    ${lib.getExe' gomod2nix "gomod2nix"} generate --dir $NEW_PATH --outdir packages/music/clscrobble
  fi
  echo "gomod2nix: Done"
''
