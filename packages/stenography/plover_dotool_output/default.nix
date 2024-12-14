{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_dotool_output";
  version = source.date;

  propagatedBuildInputs = [
    plover
  ];

  src = fetchFromGitHub {
    owner = "DarkKirb";
    repo = "plover-dotool-output";
    inherit (source) rev sha256;
  };
}
