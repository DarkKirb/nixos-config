miifox-net: { lndir, stdenvNoCC, python3Packages, ... }: stdenvNoCC.mkDerivation {
  name = "miifox.net";
  srcs = miifox-net;
  nativeBuildInputs = [
    python3Packages.chevron
    lndir
  ];
  buildPhase = ''
    chevron -d index.json index.handlebars > index.html
  '';
  installPhase = ''
    mkdir $out
    lndir -silent ${miifox-net} $out
    rm $out/index.json
  '';
}
