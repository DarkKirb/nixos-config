{ pureInputs, lib, ... }:
{
  nixpkgs.overlays = [
    (_: _: {
      inputs = pureInputs;
    })
  ];
  environment.etc."nix/inputs/nixpkgs-overlays/inputs.nix".text =
    let
      inputsToLoadString = lib.mapAttrsToList (
        name: value:
        ''${name} = ${if value._type or "" == "flake" then "loadFlake \"${value}\"" else "${value}"};''
      ) pureInputs;
    in
    ''
      _: _: let loadFlake = builtins.getFlake or (import ${pureInputs.flake-compat}); in {
        inputs = {
          ${lib.concatStringsSep "\n" inputsToLoadString}
        };
      }
    '';
}
