{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
let
  srcInfo = lib.importJSON ./source.json;
  src = fetchFromGitHub {
    owner = "twhiteman";
    repo = "pyDes";
    inherit (srcInfo) rev sha256;
  };
in
stdenvNoCC.mkDerivation {
  pname = "kodi-pydes";
  version = srcInfo.date;
  inherit src;
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/lib
    cp $src/pyDes.py $out/lib
    cp ${./addon.xml} $out/addon.xml
  '';
  meta = {
    license = lib.licenses.mit;
    description = "A pure python module which implements the DES and Triple-DES encryption algorithms.";
  };
}
