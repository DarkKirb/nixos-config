{
  fetchgit,
  buildPythonPackage,
  plover,
  hid,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_machine_hid";
  version = source.date;

  propagatedBuildInputs = [
    plover
    hid
  ];

  src = fetchgit {
    inherit (source) url rev sha256;
  };
}
