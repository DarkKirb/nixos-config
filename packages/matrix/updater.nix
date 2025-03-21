{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./mautrix-discord
  ./mautrix-python
  ./mautrix-signal
  ./mautrix-slack
  ./mautrix-telegram
  ./mautrix-whatsapp
]
