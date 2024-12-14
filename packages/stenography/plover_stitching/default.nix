{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_stitching";
  version = source.date;

  propagatedBuildInputs = [
    plover
  ];

  src = fetchFromGitHub {
    owner = "morinted";
    repo = "plover_stitching";
    inherit (source) rev sha256;
  };
}
