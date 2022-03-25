miifox-net: { stdenvNoCC, python3Packages, ... }: stdenvNoCC.mkDerivation {
  name = "miifox.net";
  srcs = miifox-net;
  nativeBuildInputs = [
    python3Packages.chevron
  ];
  buildPhase = ''
    chevron -d index.json index.handlebars > index.html
  '';
  installPhase = ''
    mkdir $out
    cp -r * $out
    rm $out/index.json
  '';
}
