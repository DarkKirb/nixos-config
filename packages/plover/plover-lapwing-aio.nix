{
  callPackage,
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,
}: let
  plover = callPackage ./plover {};
  plover-dict-commands = callPackage ./plover-dict-commands.nix {};
  plover-last-translation = callPackage ./plover-last-translation.nix {};
  plover-modal-dictionary = callPackage ./plover-modal-dictionary.nix {};
  plover-python-dictonary = callPackage ./plover-python-dictionary.nix {};
  plover-stitching = callPackage ./plover-stitching.nix {};
in
  buildPythonPackage rec {
    pname = "plover_lapwing_aio";
    version = "1.1.12";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-/JymR13kwpr7sykq1vizg2Wqc0g55rGAY7hmtuI2Weo=";
    };

    postPatch = ''
      substituteInPlace setup.cfg --replace dev11 dev10
    '';

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [
      plover
      plover-dict-commands
      plover-last-translation
      plover-modal-dictionary
      plover-python-dictonary
      plover-stitching
    ];

    meta = with lib; {
      description = "Plover plugin to install Lapwing dependencies and extras.";
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-lapwing-aio.nix"];
  }
