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
    pname = "plover_python_dictionary";
    version = "1.1.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-YlHTmMtKWUadObGbsrsF+PUspCB4Kr+amy57DQ4eCQs=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Python dictionary support for Plover.";
      license = licenses.gpl3Plus;
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-python-dictionary.nix"];
  }
