{
  stdenvNoCC,
  pngquant,
}:
{
  name,
  src,
  maxsize,
}@args:
stdenvNoCC.mkDerivation {
  dontUnpack = true;
  inherit (args) name src maxsize;
  nativeBuildInputs = [ pngquant ];
  buildPhase = ''
    ${./crushpng.sh} $src $out $maxsize
  '';
  installPhase = "true";
}
