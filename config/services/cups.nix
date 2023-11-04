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
  networking.firewall.interfaces.wg0.allowedUDPPorts = [631];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [631];

  #imports = ["${nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"];
  hardware.sane.enable = true;
}
