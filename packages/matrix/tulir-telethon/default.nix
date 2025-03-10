{
  lib,
  buildPythonPackage,
  fetchPypi,
  openssl,
  rsa,
  pyaes,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "tulir-telethon";
  version = "1.37.0a1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FckMHqGaBsqvFbrEnDWqJAQG8j/euY2NooesnxV6Kcc=";
  };

  patchPhase = ''
    substituteInPlace telethon/crypto/libssl.py --replace \
      "ctypes.util.find_library('ssl')" "'${lib.getLib openssl}/lib/libssl.so'"
  '';

  propagatedBuildInputs = [
    rsa
    pyaes
  ];

  # No tests available
  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = "https://github.com/LonamiWebs/Telethon";
    description = "Full-featured Telegram client library for Python 3";
    license = licenses.mit;
  };
}
