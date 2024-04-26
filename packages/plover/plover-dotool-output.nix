{
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonOlder,
}: let
  plover = callPackage ./plover {};
  source = builtins.fromJSON (builtins.readFile ./plover-dotool-output.json);
in
  buildPythonPackage rec {
    pname = "plover_dotool_output";
    version = source.date;
    src = fetchFromGitHub {
      owner = "darkkirb";
      repo = "plover-dotool-output";
      inherit (source) rev sha256;
    };

    doCheck = false;

    disabled = pythonOlder "3.6";
    propagatedBuildInputs = [plover];

    meta = with lib; {
      description = "Plover output plugin for dotool";
      license = licenses.mit;
    };
    passthru.updateScript = [../scripts/update-git.sh "https://github.com/darkkirb/plover-dotool-output" "plover/plover-dotool-output.json"];
  }
