{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  pythonOlder,
  sqlalchemy,
  ruamel-yaml,
  CommonMark,
  lxml,
  aiosqlite,
}:
buildPythonPackage rec {
  pname = "mautrix";
  version = "0.20.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vWfxpGex9Mg/6EbkiNjsDfmE1CWckVSOTRJQfyuhhpI=";
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

  pythonImportsCheck = ["mautrix"];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
  };
  passthru.updateScript = [../scripts/update-python-libraries "python/mautrix.nix"];
}
