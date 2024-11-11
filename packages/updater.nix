{
  lib,
  callPackage,
  writeScriptBin,
  bash,
}:
let
  script = lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [ ./art ];
in
writeScriptBin "updater" ''
  #!${bash}/bin/bash
  set -euxo pipefail
  ${script}
''
