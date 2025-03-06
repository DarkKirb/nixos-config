{
  lib,
  pureInputs,
  config,
  ...
}:
let
  # Taken from https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
  inherit (lib) filterAttrs mapAttrs';
  flakes = filterAttrs (name: value: (value ? outputs) && (name != "self")) pureInputs;
  nixRegistry = builtins.mapAttrs (name: v: { flake = v; }) flakes;
in
{
  nix.registry = nixRegistry;
  environment.etc = mapAttrs' (name: value: {
    name = "nix/inputs/${name}";
    value = lib.mkIf config.nix.enable {
      source = value.outPath;
    };
  }) flakes;
  nix.nixPath = [ "/etc/nix/inputs" ];
}
