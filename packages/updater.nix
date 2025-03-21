{
  lib,
  callPackage,
  writeScriptBin,
  bash,
  nix,
}:
let
  script = lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
    ./anubis
    ./art
    ./kodi
    ./matrix
    ./music
    ./stenography
  ];
in
writeScriptBin "updater" ''
  #!${lib.getExe bash}
  set -euxo pipefail
  ${lib.getExe nix} flake update
  ${script}
''
