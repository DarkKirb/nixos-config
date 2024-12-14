{
  lib,
  callPackage,
}:
lib.concatMapStringsSep "\n" (f: callPackage "${f}/updater.nix" { }) [
  ./plover
  ./plover_dict_commands
  ./plover_dotool_output
  ./plover_lapwing_aio
  ./plover_last_translation
  ./plover_machine_hid
  ./plover_modal_dictionary
  ./plover_plugins_manager
  ./plover_python_dictionary
  ./plover_stitching
  ./plover_stroke
  ./rtf_tokenize
]
