{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./plover
  ./plover_stroke
  ./rtf_tokenize
]
