{ config, pkgs, ... }:
{
  imports = [
    ./steam
  ];
  home-manager.users.darkkirb.imports =
    if config.isGraphical then
      [
        ./home-manager.nix
      ]
    else
      [ ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
  ];

  home.persistence.default.directories = [
    ".local/share/kwalletd"
  ];

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
}
