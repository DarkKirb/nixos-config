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
    pname = "plover-stenotype-extended";
    version = "1.0.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-IC9eGs5tMvA13h9STQtp5kfSVvSe2lIWzbPZCqoBZbU=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Plover plugin for an extended Stenotype layout.";
      license = licenses.gpl3Plus;
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-stenotype-extended.nix"];
  }
