{ stdenvNoCC, fetchurl, ... }:
let file = fetchurl {
  url = "https://wyub.github.io/tokipona/linja-sike-5.otf";
  sha256 = "12pxivj8dxkfk97zc6yq04dlxjl4wrs2ia1wzzyidj4vmqh0m5sc";
}; in
stdenvNoCC.mkDerivation {
  pname = "linja-sike";
  version = "5";
  buildCommand = ''
    install -m444 -Dt $out/share/fonts/opentype/linja-sike ${file}
  '';
}
