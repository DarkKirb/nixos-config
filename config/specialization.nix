# Configuration file configuring specialization
{ pkgs, config, lib, ... }: {
  nixpkgs.overlays = [
    (self: prev: {
      custom_xanmod = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_xanmod.override {
        ignoreConfigErrors = true;
        autoModules = false;
        kernelPreferBuiltin = true;
        enableParallelBuilding = true;
        extraConfig = import (../extra/linux/config- + "${config.networking.hostName}.nix");
      });
    })
  ];
}
