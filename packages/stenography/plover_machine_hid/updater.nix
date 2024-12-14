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
  echo "plover-machine-hid: Checking for updates"
  CURRENT_COMMIT=$(${curl}/bin/curl https://git.chir.rs/api/v1/repos/darkkirb/plover-machine-hid/commits | ${jq}/bin/jq -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "plover-machine-hid: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://git.chir.rs/darkkirb/plover-machine-hid | ${jq}/bin/jq > packages/stenography/plover_machine_hid/source.json
  fi
  echo "plover-machine-hid: Done"
''
