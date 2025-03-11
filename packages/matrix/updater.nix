{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./mautrix-discord
  ./mautrix-python
  ./mautrix-telegram
]
