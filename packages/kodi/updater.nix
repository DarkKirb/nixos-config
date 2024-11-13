{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./joyn
]
