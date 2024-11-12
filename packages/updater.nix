{
  lib,
  callPackage,
  writeScriptBin,
  bash,
  nix,
}:
let
  script = lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [ ./art ];
in
writeScriptBin "updater" ''
  #!${bash}/bin/bash
  set -euxo pipefail
  ${nix}/bin/nix flake update
  ${script}
''
