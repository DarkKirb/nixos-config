{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  pythonOlder,
  sqlalchemy,
  ruamel-yaml,
  CommonMark,
  lxml,
  aiosqlite,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "mautrix";
  version = "0.20.6";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    inherit (source) rev sha256;
  };

  propagatedBuildInputs = [
    aiohttp

    # defined in optional-requirements.txt
    sqlalchemy
    aiosqlite
    ruamel-yaml
    CommonMark
    lxml
  ];

  disabled = pythonOlder "3.8";

  # no tests available
  doCheck = false;

  pythonImportsCheck = [ "mautrix" ];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
  };
}
