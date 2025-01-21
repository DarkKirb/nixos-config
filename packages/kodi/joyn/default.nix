{
  buildKodiAddon,
  fetchFromGitHub,
  inputstream-adaptive,
  inputstreamhelper,
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
    owner = "Maven85";
    repo = "plugin.video.joyn";
    inherit (srcInfo) rev sha256;
  };
  preFixup = ''
    substituteInPlace $out/share/kodi/addons/plugin.video.joyn/addon.xml --replace-fail '2.26.0' '3.0.0' 
  '';
  propagatedBuildInputs = [
    inputstream-adaptive
    inputstreamhelper
    simplejson
  ];
  meta = {
    license = lib.licenses.gpl2;
    description = "Watch VOD content und Live TV provided by Joyn";
  };
}
