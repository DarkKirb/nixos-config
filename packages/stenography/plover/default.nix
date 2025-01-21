{
  lib,
  fetchFromGitHub,
  python3Packages,
  plover_stroke,
  rtf_tokenize,
  qt5,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
with python3Packages;
qt5.mkDerivationWith buildPythonPackage {
  pname = "plover";
  version = source.date;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "OpenSteno Plover stenography software";
    license = licenses.gpl2;
  };

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover";
    inherit (source) rev sha256;
  };

  # I'm not sure why we don't find PyQt5 here but there's a similar
  # sed on many of the platforms Plover builds for
  postPatch = "sed -i /PyQt5/d setup.cfg";

  nativeCheckInputs = [
    pytest
    mock
  ];
  propagatedBuildInputs = [
    appdirs
    babel
    pyqt5
    xlib
    pyserial
    wcwidth
    setuptools
    rtf_tokenize
    plover_stroke
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';
}
