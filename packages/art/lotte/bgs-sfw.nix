{ art-lotte, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "sfw-bgs";
  inherit (art-lotte) version;
  src = art-lotte;
  dontUnpack = true;
  dontBuild = true;
  sfwBgs = [
    "2020-07-24-urbankitsune-bna-ych.jxl"
    "2021-09-15-cloverhare-lotteplush.jxl"
    "2022-05-02-anonfurryartist-giftart.jxl"
    "2022-06-21-sammythetanuki-lotteplushpride.jxl"
    "2022-11-15-wolfsifi-maff-me-leashed.jxl"
  ];
  installPhase = ''
    mkdir $out
    for f in $sfwBgs; do
      ln -svf $src/$f $out/$f
    done
  '';

  meta = {
    description = "SFW computer backgrounds";
    inherit (art-lotte.meta) license;
  };
}
