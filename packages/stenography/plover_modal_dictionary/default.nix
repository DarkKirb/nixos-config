{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_modal_dictionary";
  version = source.date;

  propagatedBuildInputs = [
    plover
  ];

  src = fetchFromGitHub {
    owner = "Kaoffie";
    repo = "plover_modal_dictionary";
    inherit (source) rev sha256;
  };
}
