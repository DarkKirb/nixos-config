{
  emptyDirectory,
  stdenv,
  imagemagick,
  runCommand,
  palette-generator,
  art-lotte,
  lib,
  ...
}:
let
  imgPng =
    img:
    stdenv.mkDerivation {
      name = "bg.png";
      src = emptyDirectory;
      nativeBuildInputs = [ imagemagick ];
      buildPhase = ''
        magick ${img} $out
      '';
      installPhase = "true";
    };
  mkPalette =
    img: polarity:
    (runCommand "palette.json" { } ''
      ${palette-generator}/bin/palette-generator ${polarity}  ${lib.escapeShellArg "${imgPng img}"} "$out"
    '').overrideAttrs
      {
        passthru.img = imgPng img;
      };
  mkPalettes = img: {
    either = mkPalette img "either";
    dark = mkPalette img "dark";
    light = mkPalette img "light";
  };

in
lib.listToAttrs (
  map
    (name: {
      inherit name;
      value = mkPalettes "${art-lotte}/${name}.jxl";
    })
    [
      "2020-07-24-urbankitsune-bna-ych"
      "2021-09-15-cloverhare-lotteplush"
      "2022-05-02-anonfurryartist-giftart"
      "2022-06-21-sammythetanuki-lotteplushpride"
      "2022-11-15-wolfsifi-maff-me-leashed"
      "2021-10-29-butterskunk-lotte-scat-buffet"
      "2021-11-27-theroguez-lottegassyvore1"
      "2021-12-12-baltnwolf-christmas-diaper-messy"
      "2021-12-12-baltnwolf-christmas-diaper"
      "2022-04-20-cloverhare-mxbatty-maffsie-train-plush"
      "2022-04-20-cloverhare-mxbatty-me-train-maffsie-plush"
      "2022-08-12-deathtoaster-funpit-scat"
      "2022-08-15-deathtoaster-funpit-mud"
      "2022-12-27-rexyi-scatych"
      "2023-03-09-rexyi-voredisposal-ych"
      "2023-08-09-coldquarantine-lotte-eating-trash"
      "2023-08-10-coldquarantine-lotte-eating-trash-diapers"
      "2023-08-20-coldquarantine-lotte-eating-trash-clean"
    ]
)
