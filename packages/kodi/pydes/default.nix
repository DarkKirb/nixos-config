{ callPackage, buildKodiAddon }:
let
  src = callPackage ./source.nix { };
in
buildKodiAddon {
  pname = "pyDes";
  namespace = "script.module.pydes";
  version = "2.0.1";
  inherit src;
  inherit (src) meta;
}
