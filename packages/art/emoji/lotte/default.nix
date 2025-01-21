{
  callPackage,
  stdenvNoCC,
  libjxl,
  imagemagick,
  lib,
  art-lotte,
}:
let
  crushpng = callPackage ../lib/crushpng.nix { };
  resized =
    name:
    stdenvNoCC.mkDerivation {
      inherit name;
      src = art-lotte;
      nativeBuildInputs = [
        libjxl
        imagemagick
      ];
      buildPhase = ''
        convert $name.jxl -scale 256x256\> $name-scaled.png
      '';
      installPhase = ''
        cp $name-scaled.png $out
      '';
    };
  lnEmojiScript = f: ''
    ln -s ${
      crushpng {
        name = f.from;
        src = resized f.from;
        maxsize = 50000;
      }
    } $out/${f.to}.png
  '';
  emoji = [
    {
      from = "2019-10-05-dae-lotteheart";
      to = "lotteheart";
    }
    {
      from = "2019-10-05-dae-lottehearts";
      to = "lottehearts";
    }
    {
      from = "2019-10-05-dae-lottepet";
      to = "lottepet";
    }
    {
      from = "2019-11-17-workerq-lottetrash";
      to = "lottetrashcan";
    }
    {
      from = "2020-01-05-dae-lotteweary";
      to = "lotteweary";
    }
    {
      from = "2020-01-17-workerq-lotteblep";
      to = "lotteblep";
    }
    {
      from = "2020-01-17-workerq-lottecoffee";
      to = "lottecoffee";
    }
    {
      from = "2020-01-17-workerq-lottecookie";
      to = "lottecookie";
    }
    {
      from = "2020-01-17-workerq-lottehug";
      to = "lottehug";
    }
    {
      from = "2020-01-17-workerq-lottesmile";
      to = "lottesmile";
    }
    {
      from = "2021-03-23-sammythetanuki-lottegoodsalt";
      to = "lottegoods";
    }
    {
      from = "2021-03-26-zomlette-agender-screem-tp";
      to = "lottescreem";
    }
    {
      from = "2021-04-21-sammythetanuki-lottecoffeemachine";
      to = "lottecoffeemachine";
    }
    {
      from = "2021-05-03-sammythetanuki-lotteflatfuck";
      to = "lotteflatfuck";
    }
    {
      from = "2021-05-03-sammythetanuki-lottehug";
      to = "lottehug2";
    }
    {
      from = "2021-05-03-sammythetanuki-lottesnuggle";
      to = "lottesnuggle";
    }
    {
      from = "2021-05-03-sammythetanuki-lottetrash";
      to = "lottetrashwave";
    }
    {
      from = "2021-05-04-mizuki-lotteshocked-sticker";
      to = "lotteshocked";
    }
    {
      from = "2021-05-29-sammythetanuki-lottepizza";
      to = "lottepizza";
    }
    {
      from = "2021-07-02-sammythetanuki-lottegrab";
      to = "lottegrab";
    }
    {
      from = "2021-07-16-sammythetanuki-lottecarostacc";
      to = "lottecarostacc";
    }
    {
      from = "2021-08-03-sammythetanuki-everyonesproblem";
      to = "lotteveryonesproblem";
    }
    {
      from = "2021-08-20-mizuki-peekabu-sticker";
      to = "lottepeekabu";
    }
    {
      from = "2021-09-13-sammythetanuki-plushhug";
      to = "lotteplushhug";
    }
    {
      from = "2021-10-28-pulexart-me-climbTree";
      to = "lotteclimbtree";
    }
    {
      from = "2021-10-28-pulexart-me-dab";
      to = "lottedab";
    }
    {
      from = "2021-10-28-pulexart-me-eatingPopcorn";
      to = "lotteeatingpopcorn";
    }
    {
      from = "2021-10-28-pulexart-me-flirt";
      to = "lotteflirt";
    }
    {
      from = "2021-10-28-pulexart-me-garbage";
      to = "lottegarbage";
    }
    {
      from = "2021-10-28-pulexart-me-heartAce";
      to = "lotteheartace";
    }
    {
      from = "2021-10-28-pulexart-me-heartAgender";
      to = "lotteheartagender";
    }
    {
      from = "2021-10-28-pulexart-me-heartLGBT";
      to = "lotteheartlgbt";
    }
    {
      from = "2021-10-28-pulexart-me-heartNonbinary";
      to = "lotteheartnonbinary";
    }
    {
      from = "2021-10-28-pulexart-me-heartNormal";
      to = "lotteheartnormal";
    }
    {
      from = "2021-10-28-pulexart-me-heartRaccoongender";
      to = "lotteheartraccoongender";
    }
    {
      from = "2021-10-28-pulexart-me-heartTrans";
      to = "lottehearttrans";
    }
    {
      from = "2021-10-28-pulexart-me-money";
      to = "lottemoney";
    }
    {
      from = "2021-10-28-pulexart-me-noU";
      to = "lottenou";
    }
    {
      from = "2021-10-28-pulexart-me-plotting";
      to = "lotteplotting";
    }
    {
      from = "2021-10-28-pulexart-me-praise";
      to = "lottepraise";
    }
    {
      from = "2021-10-28-pulexart-me-robber";
      to = "lotterobber";
    }
    {
      from = "2021-10-28-pulexart-me-sleepy";
      to = "lottesleepy";
    }
    {
      from = "2021-10-28-pulexart-me-sneak";
      to = "lottesneak";
    }
    {
      from = "2021-10-28-pulexart-me-trash";
      to = "lottetrashcan2";
    }
    {
      from = "2021-10-28-pulexart-me-washingFood";
      to = "lottewashingfood";
    }
    {
      from = "2021-11-14-sammythetanuki-lottepat";
      to = "lottepat";
    }
    {
      from = "2021-12-18-sammythetanuki-lottecookies";
      to = "lottecookies";
    }
    {
      from = "2021-12-20-sammythetanuki-lottecrimmus";
      to = "lottecrimmus";
    }
    {
      from = "2022-01-08-sammythetanuki-lotteangry";
      to = "lotteangry";
    }
    {
      from = "2022-01-08-sammythetanuki-lottepleading";
      to = "lottepleading";
    }
    {
      from = "2022-02-20-sammythetanuki-lottehacking-notext";
      to = "lottehacking";
    }
    {
      from = "2022-05-05-sammythetanuki-lotteass";
      to = "lotteass";
    }
    {
      from = "2022-06-13-sammythetanuki-lotteplushnothoughts";
      to = "lotteplushnothoughts";
    }
    {
      from = "2022-07-14-sammythetanuki-maybecringe-transparent";
      to = "lottemaybecringe";
    }
    {
      from = "2022-11-06-pulexart-me-heartTherian";
      to = "lottehearttherian";
    }
    {
      from = "2022-11-10-mizuki-peekabu";
      to = "lottepeekabudiaper";
    }
  ];
in
stdenvNoCC.mkDerivation {
  name = "lotte-emoji";
  dontUnpack = true;
  buildPhase = "true";
  installPhase = ''
    mkdir $out
    ${toString (map lnEmojiScript emoji)}
  '';
  meta = {
    description = "Stickers and emoji for the fediverse";
    license = lib.licenses.cc-by-nc-sa-40;
  };
}
