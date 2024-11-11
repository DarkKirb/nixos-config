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
  echo "lotte-art: Checking for updates"
  CURRENT_COMMIT=$(${curl}/bin/curl https://git.chir.rs/api/v1/repos/darkkirb/lotte-art/commits | ${jq}/bin/jq -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "lotte-art: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://git.chir.rs/darkkirb/lotte-art --fetch-lfs | ${jq}/bin/jq > packages/art/lotte/source.json
  fi
  echo "lotte-art: Done"
''
