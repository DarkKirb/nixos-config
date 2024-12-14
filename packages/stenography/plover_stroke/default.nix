{
  fetchFromGitHub,
  buildPythonPackage,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_stroke";
  version = source.date;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover_stroke";
    inherit (source) rev sha256;
  };
}
