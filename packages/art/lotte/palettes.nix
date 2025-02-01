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
    magickCommand:
    stdenv.mkDerivation {
      name = "bg.png";
      src = emptyDirectory;
      nativeBuildInputs = [ imagemagick ];
      buildPhase = ''
        magick ${magickCommand} $out
      '';
      installPhase = "true";
    };
  mkPalette =
    img: magickCommand: polarity:
    (runCommand "palette.json" { } ''
      ${lib.getExe' palette-generator "palette-generator"} ${polarity}  ${lib.escapeShellArg "${imgPng magickCommand}"} "$out"
    '').overrideAttrs
      {
        passthru.img = imgPng img;
      };
  mkPalettes = img: magickCommand: {
    either = mkPalette img magickCommand "either";
    dark = mkPalette img magickCommand "dark";
    light = mkPalette img magickCommand "light";
  };

in
lib.listToAttrs (
  map
    (
      value:
      let
        name = if lib.isString value then value else value.name;
        imgFile = "${art-lotte}/${name}.jxl";
        magickCommand = if lib.isString value then imgFile else (value.magickCommand imgFile);
      in
      {
        inherit name;
        value = mkPalettes imgFile magickCommand;
      }
    )
    [
      "2020-07-24-urbankitsune-bna-ych"
      "2021-09-15-cloverhare-lotteplush"
      "2022-05-02-anonfurryartist-giftart"
      "2021-06-20-sammythetanuki-skonks-colored"
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
      {
        name = "2023-04-03-sibyl-lottehosesuit";
        magickCommand = img: "-size 4551x2560 xc:#263736 ${img} -gravity center -composite";
      }
      {
        name = "2023-04-03-sibyl-lottehosesuit-edited";
        magickCommand = img: "-size 4551x2560 xc:#263736 ${img} -gravity center -composite";
      }
      {
        name = "2023-04-16-baltnwolf-lottediaperplushies";
        magickCommand = img: "-size 5333x3000 xc:white ${img} -gravity center -composite";
      }
      {
        name = "2023-04-16-baltnwolf-lottediaperplushies-messy";
        magickCommand = img: "-size 5333x3000 xc:white ${img} -gravity center -composite";
      }
      "2023-08-09-coldquarantine-lotte-eating-trash"
      "2023-08-10-coldquarantine-lotte-eating-trash-diapers"
      "2023-08-20-coldquarantine-lotte-eating-trash-clean"
      {
        name = "2023-10-31-zombineko-lotteplushpunished-blowout";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2023-10-31-zombineko-lotteplushpunished-messier";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2023-10-31-zombineko-lotteplushpunished-messier-nodiaper";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2023-10-31-zombineko-lotteplushpunished-messy";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2023-10-31-zombineko-lotteplushpunished-messy-nodiaper";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2023-10-31-zombineko-lotteplushpunished-outside";
        magickCommand =
          img:
          "\( ${img} -gravity west -crop 86x4085+0+0 +repage \) -write mpr:sometile +delete -size 7262x4085 tile:mpr:sometile ${img} -gravity east";
      }
      {
        name = "2025-01-24-crepes-lottediaperpail-tp";
        magickCommand = img: "-size 2560x1440 gradient:#4fa3b0-#e1ffee ${img} -gravity center -composite";
      }
    ]
)
