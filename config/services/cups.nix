{
  pkgs,
  nixpkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
    ];
    browsing = true;
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    defaultShared = true;
    extraConf = ''
      ServerAlias *
    '';
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  #imports = ["${nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"];
  hardware.sane.enable = true;
}
