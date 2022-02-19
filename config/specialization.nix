# Configuration file configuring specialization
{ config, ... }: {
  nixpkgs.overlays = [
    (self: prev: {
      linuxKernel.kernels.linux_xanmod = prev.linuxKernel.manualConfig {
        inherit (prev) stdenv hostPlatform;
        inherit (prev.linuxKernel.kernels.linux_xanmod) src version;
        configfile = ../extra/linux/config-${config.networking.hostName};
      };
    })
  ];
}
