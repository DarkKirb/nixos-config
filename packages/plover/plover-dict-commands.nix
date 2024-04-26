{
  callPackage,
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,
  setuptools,
  setuptools-scm,
}: let
  plover = callPackage ./plover {};
in
  buildPythonPackage rec {
    pname = "plover_dict_commands";
    version = "0.2.5";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-ki/M5V106YbQMjZQmkTNyBzFboVYi/x0hkLAXqPyk8Q=";
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover setuptools setuptools-scm];

    meta = with lib; {
      description = "Dictionaries stack manipulation commands for Plover.";
    };
    passthru.updateScript = [../scripts/update-python-libraries "plover/plover-dict-commands.nix"];
  }
