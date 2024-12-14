{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_last_translation";
  version = source.date;

  propagatedBuildInputs = [
    plover
  ];

  src = fetchFromGitHub {
    owner = "nsmarkop";
    repo = "plover_last_translation";
    inherit (source) rev sha256;
  };
}
