{
  fetchFromGitHub,
  buildPythonPackage,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "rtf_tokenize";
  version = source.date;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "rtf_tokenize";
    inherit (source) rev sha256;
  };
}
