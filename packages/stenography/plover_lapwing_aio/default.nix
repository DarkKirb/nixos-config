{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
  plover_dict_commands,
  plover_last_translation,
  plover_modal_dictionary,
  plover_python_dictionary,
  plover_stitching,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_lapwing_aio";
  version = source.date;

  propagatedBuildInputs = [
    plover
    plover_dict_commands
    plover_last_translation
    plover_modal_dictionary
    plover_python_dictionary
    plover_stitching
  ];

  src = fetchFromGitHub {
    owner = "aerickt";
    repo = "plover-lapwing-aio";
    inherit (source) rev sha256;
  };
}
