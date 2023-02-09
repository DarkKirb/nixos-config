# Configuration file configuring specialization
{
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: prev: {
    })
  ];
  environment.etc."nix/local-system.json".text = builtins.toJSON {
    inherit (config.nixpkgs.localSystem) system gcc rustc linux-kernel;
  };
}
