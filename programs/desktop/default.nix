{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./steam
    ./kodi/system-config.nix
    ./pipewire.nix
    ./firefox/system.nix
    ./development/system.nix
    ./ollama-ui.nix
  ];
  home-manager.users.darkkirb.imports =
    if config.system.isGraphical then
      [
        ./home-manager.nix
      ]
    else
      [ ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
  ];

  networking.firewall.allowedTCPPorts = [ 2234 ];
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
