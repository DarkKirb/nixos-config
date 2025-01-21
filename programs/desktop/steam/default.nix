{
  lib,
  config,
  system,
  ...
}:
{
  programs.steam = lib.mkIf config.isGraphical {
    enable = !config.isInstaller && (system == "x86_64-linux");
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  nixpkgs.config.allowUnfree = true;

  home-manager.users.darkkirb.imports = if config.isGraphical then [ ./home-manager.nix ] else [ ];
}
