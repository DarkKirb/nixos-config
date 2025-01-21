{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
  setuptools,
  setuptools-scm,

}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_dict_commands";
  version = source.date;

  propagatedBuildInputs = [
    plover
    setuptools
    setuptools-scm

  ];

  src = fetchFromGitHub {
    owner = "KoiOates";
    repo = "plover_dict_commands";
    inherit (source) rev sha256;
  };
}
