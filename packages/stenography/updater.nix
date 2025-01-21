{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./plover
  ./plover_dict_commands
  ./plover_lapwing_aio
  ./plover_last_translation
  ./plover_modal_dictionary
  ./plover_plugins_manager
  ./plover_python_dictionary
  ./plover_stitching
  ./plover_stroke
  ./plover_uinput
  ./rtf_tokenize
]
