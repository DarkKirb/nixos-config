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
    pname = "plover-modal-dictionary";
    version = "0.0.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-qLr5H6ZvPhzG4Wa6dK45iReABO0EvA5+2afp2ctnc1A=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Dictionaries stack manipulation commands for Plover.";
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-modal-dictionary"];
  }
