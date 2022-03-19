{ nixpkgs, ... } @ inputs: channels:
let
  pkgs = channels.nixpkgs;
  lib = nixpkgs.lib;
  pkg_srcs = [
    ./neo.nix
  ];
in
lib.lists.foldr (a: b: a // b) { } (map (src: import src (inputs // { inherit channels; })) pkg_srcs)
