{
  lib,
  config,
  system,
  ...
}:
{
  programs.steam = lib.mkIf config.system.isGraphical {
    enable = !config.system.isInstaller && (system == "x86_64-linux");
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  home-manager.users.darkkirb.imports =
    if config.system.isGraphical then [ ./home-manager.nix ] else [ ];
}
