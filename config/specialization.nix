# Configuration file configuring specialization
{ config, ... }: {
  nixpkgs.overlays = [
    (self: prev: {
      linuxKernel.kernels.linux_xanmod = super.linuxKernel.manualConfig {
        inherit (super) stdenv hostPlatform;
        inherit (super.linuxKernel.kernels.linux_xanmod) src version;
        configfile = ../extra/linux/config-${config.networking.hostName};
      };
    })
  ];
}
