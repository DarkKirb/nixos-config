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
    pname = "plover_stitching";
    version = "0.1.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-08wsVTf89kKattOM0Uj/R/heW9zSX7JQBcza8aJJwxc=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Stitch words like T-H-I-S using Plover strokes";
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-stitching.nix"];
  }
