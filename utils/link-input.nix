inputs': {
  system,
  lib,
  ...
}: let
  # Taken from https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
  inherit (lib) filterAttrs mapAttrs';
  inputs =
    inputs'
    // {
      nixpkgs = import ./patched-nixpkgs.nix {
        inherit (inputs') nixpkgs;
        inherit system;
        patches = "${inputs'.self}/extra/nixpkgs.patch";
      };
    };
  flakes = filterAttrs (name: value: value ? outputs) inputs;
  nixRegistry =
    builtins.mapAttrs
    (name: v: {flake = v;})
    flakes;
in {
  nix.registry = nixRegistry;
  environment.etc =
    mapAttrs'
    (name: value: {
      name = "nix/inputs/${name}";
      value = {source = value.outPath;};
    })
    inputs;
  environment.etc."nix/inputs/nixpkgs-overlays".source = ./nixpkgs-overlays;
  nix.nixPath = ["/etc/nix/inputs"];
}
