{
  callPackage,
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,
}: let
  plover = callPackage ./plover {};
in
  buildPythonPackage rec {
    pname = "plover_last_translation";
    version = "0.0.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-lmgjbuwdqZ8eeU4m/d1akFwwj5CmliEaLmXEKAubjdk=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Dictionaries stack manipulation commands for Plover.";
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-last-translation.nix"];
  }
