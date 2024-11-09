{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  badNames = [
    "system"
    "override"
    "overrideDerivation"
  ];
  filterBad = filterAttrs (n: _: lib.all (m: n != m) badNames);
in
{
  options.autoContainers = mkOption {
    default = [ ];
    type = types.listOf types.str;
    description = "names of containers to automatically set up";
  };
  config = {
    containers = listToAttrs (
      map (container: {
        name = container;
        value = filterBad (pkgs.callPackage ../../containers/${container}-configuration.nix { }) // {
          specialArgs = inputs;
        };
      }) config.autoContainers
    );
  };
}
