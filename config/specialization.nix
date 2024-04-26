# Configuration file configuring specialization
{
  gomod2nix,
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: prev: {
      custom_xanmod = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_xanmod.override {
        ignoreConfigErrors = true;
        autoModules = true;
        kernelPreferBuiltin = true;
        enableParallelBuilding = true;
        extraConfig = import (../extra/linux/config- + "${config.networking.hostName}.nix");
      });
    })
    gomod2nix.overlays.default
  ];
}
