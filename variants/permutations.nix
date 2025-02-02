{ lib, ... }:
let
  permutations = a: b: lib.flatten (map (x: map (y: x // y) b) a);
  values = {
    bg = [
      { bg = "sfw"; }
      { bg = "nsfw"; }
    ];
    boot = [
      { boot = "plymouth"; }
      { boot = "verbose"; }
    ];
    de = [
      { de = "kde"; }
      { de = "sway"; }
    ];
    polarity = [
      { polarity = "dark"; }
      { polarity = "either"; }
      { polarity = "light"; }
    ];
  };
in
variants:
lib.foldl (a: b: permutations a values.${b}) values.${lib.head variants} (lib.tail variants)
