{
  fetchgit,
  lib,
}:
let
  srcInfo = lib.importJSON ./source.json;
  src = fetchgit {
    inherit (srcInfo)
      url
      rev
      sha256
      fetchLFS
      fetchSubmodules
      deepClone
      leaveDotGit
      ;
  };
in
src.overrideAttrs (_: rec {
  name = "${pname}-${version}";
  pname = "lotte-art";
  version = srcInfo.date;
  meta = {
    description = "Art I commissioned or made";
    license = lib.licenses.cc-by-nc-sa-40;
  };
})
