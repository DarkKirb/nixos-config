{
  lib,
  callPackage,
  writeScriptBin,
  fish,
}:
let
  script = lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [ ./art ];
in
writeScriptBin "updater" ''
  #!${fish}/bin/fish
  ${script}
''
