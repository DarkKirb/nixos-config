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
  echo "yiffstash: Checking for updates"
  CURRENT_COMMIT=$(${lib.getExe curl} https://git.chir.rs/api/v1/repos/darkkirb/yiffstash/commits | ${lib.getExe jq} -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "yiffstash: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${lib.getExe' nix-prefetch-git "nix-prefetch-git"} https://git.chir.rs/darkkirb/yiffstash --fetch-lfs | ${lib.getExe jq} > packages/art/yiffstash/source.json
  fi
  echo "yiffstash: Done"
''
