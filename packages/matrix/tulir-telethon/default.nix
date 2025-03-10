{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  rsa,
  pyaes,
  pythonOlder,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "tulir-telethon";
  version = source.date;

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "Telethon";
    inherit (source) rev sha256;
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
