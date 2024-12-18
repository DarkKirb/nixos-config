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
    substituteInPlace plover_uinput/__init__.py --replace-fail "assert isinstance" "#" \
      --replace-fail '"super": e.KEY_LEFTMETA,' '"super": e.KEY_LEFTMETA, "caps": e.KEY_CAPSLOCK,'
    substituteInPlace plover_uinput/symbols.py --replace-fail 'ctx.keymap_new_from_names(layout=layout)' 'ctx.keymap_new_from_names(layout="de", variant="neo")' \
      --replace-fail '2: "alt_r",' '2: "caps",' \
      --replace-fail '3: "shift_l alt_r",' '3: "alt_r", 4: "caps shift_l", 5: "caps alt_r"'
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
