{
  callPackage,
  buildPythonPackage,
  fetchgit,
  lib,
  pythonOlder,
  hid,
  bitstring,
}: let
  plover = callPackage ./plover {};
  source = builtins.fromJSON (builtins.readFile ./plover-rkb1-hid.json);
in
  buildPythonPackage {
    pname = "plover_machine_hid";
    version = source.date;
    src = fetchgit {
      inherit (source) rev sha256 url;
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover hid bitstring];

    meta = with lib; {
      description = "POC Plover plugin and firmware for the Plover HID protocol";
      license = licenses.mit;
    };
    passthru.updateScript = [../scripts/update-git.sh "https://git.chir.rs/darkkirb/plover-machine-hid" "plover/plover-rkb1-hid.json"];
  }
