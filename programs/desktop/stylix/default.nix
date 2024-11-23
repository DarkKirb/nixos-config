{
  pkgs,
  nixos-config,
  nixpkgs,
  lib,
  config,
  ...
}:
let
  sfw-bgs = [
    "2020-07-24-urbankitsune-bna-ych.jxl"
    "2021-09-15-cloverhare-lotteplush.jxl"
    "2022-05-02-anonfurryartist-giftart.jxl"
    "2022-06-21-sammythetanuki-lotteplushpride.jxl"
    "2022-11-15-wolfsifi-maff-me-leashed.jxl"
  ];
  nsfw-bgs = [
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
  mod = a: b: a - (a / b * b);
  choose =
    l: rand:
    let
      len = builtins.length l;
    in
    builtins.elemAt l (mod rand len);
  hexToIntList = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };
  hexToInt =
    s: lib.foldl (state: new: state * 16 + hexToIntList.${new}) 0 (lib.strings.stringToCharacters s);
  seed = hexToInt (nixos-config.shortRev or nixpkgs.shortRev);
  bg = choose (if config.isNSFW then nsfw-bgs else sfw-bgs) seed;
  bgPng = pkgs.stdenv.mkDerivation {
    name = "bg.png";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = [ pkgs.imagemagick ];
    buildPhase = ''
      magick ${pkgs.art-lotte}/${bg} $out
    '';
    installPhase = "true";
  };
in
{
  home-manager.users.root.stylix.enable = lib.mkForce false;
  stylix = {
    enable = true;
    image = bgPng;
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "Noto"
          ];
        };
        name = "FiraCode Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
