{ art-lotte, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "nsfw-bgs";
  inherit (art-lotte) version;
  src = art-lotte;
  dontUnpack = true;
  dontBuild = true;
  nsfwBgs = [
    "2020-07-24-urbankitsune-bna-ych.jxl"
    "2021-09-15-cloverhare-lotteplush.jxl"
    "2021-10-29-butterskunk-lotte-scat-buffet.jxl"
    "2021-11-27-theroguez-lottegassyvore1.jxl"
    "2021-12-12-baltnwolf-christmas-diaper-messy.jxl"
    "2021-12-12-baltnwolf-christmas-diaper.jxl"
    "2022-04-20-cloverhare-mxbatty-maffsie-train-plush.jxl"
    "2022-04-20-cloverhare-mxbatty-me-train-maffsie-plush.jxl"
    "2022-05-02-anonfurryartist-giftart.jxl"
    "2022-06-21-sammythetanuki-lotteplushpride.jxl"
    "2022-08-12-deathtoaster-funpit-scat.jxl"
    "2022-08-15-deathtoaster-funpit-mud.jxl"
    "2022-11-15-wolfsifi-maff-me-leashed.jxl"
    "2022-12-27-rexyi-scatych.jxl"
    "2023-03-09-rexyi-voredisposal-ych.jxl"
    "2023-08-09-coldquarantine-lotte-eating-trash.jxl"
    "2023-08-10-coldquarantine-lotte-eating-trash-diapers.jxl"
    "2023-08-20-coldquarantine-lotte-eating-trash-clean.jxl"
  ];
  installPhase = ''
    mkdir $out
    for f in $nsfwBgs; do
      cp $src/$f $out/$f
    done
  '';

  meta = {
    description = "NSFW computer backgrounds";
    inherit (art-lotte.meta) license;
  };
}
