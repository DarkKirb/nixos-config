{
  buildKodiAddon,
  fetchFromGitHub,
  inputstream-adaptive,
  inputstreamhelper,
  kodi-pydes,
  lib,
  simplejson,
}:
let
  srcInfo = lib.importJSON ./source.json;
in
buildKodiAddon {
  pname = "Joyn";
  namespace = "plugin.video.joyn";
  version = "2.3.1.10";
  src = fetchFromGitHub {
    owner = "knaerzche";
    repo = "plugin.video.joyn";
    inherit (srcInfo) rev sha256;
  };
  postPatch = ''
    substituteInPlace --replace '2.26.0' '3.0.0' addon.xml
  '';
  propagatedBuildInputs = [
    inputstream-adaptive
    inputstreamhelper
    kodi-pydes
    simplejson
  ];
  meta = {
    license = lib.licenses.gpl2;
    description = "Watch VOD content und Live TV provided by Joyn";
  };
}
