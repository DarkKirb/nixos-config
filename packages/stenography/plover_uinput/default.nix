{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
  evdev,
  xkbcommon,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_uinput";
  version = source.date;

  patchPhase = ''
    rm -rf plover_uinput.egg-info
    rm -rf dist
    substituteInPlace setup.cfg --replace-fail "xkbcommon<1.1" "xkbcommon"
    substituteInPlace plover_uinput/__init__.py --replace-fail "assert isinstance" "#"
  '';

  propagatedBuildInputs = [
    evdev
    plover
    xkbcommon
  ];

  src = fetchFromGitHub {
    owner = "LilleAila";
    repo = "plover-uinput";
    inherit (source) rev sha256;
  };
}
