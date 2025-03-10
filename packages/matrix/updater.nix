{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./mautrix-python
  ./mautrix-telegram
  ./tulir-telethon
]
