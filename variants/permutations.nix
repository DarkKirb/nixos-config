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
  };
in
variants:
if variants == [ ] then
  [ ]
else
  lib.foldl (a: b: permutations a values.${b}) values.${lib.head variants} (lib.tail variants)
