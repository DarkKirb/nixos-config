{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_python_dictionary";
  version = source.date;

  propagatedBuildInputs = [
    plover
  ];

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover_python_dictionary";
    inherit (source) rev sha256;
  };
}
