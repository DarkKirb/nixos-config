{
  config,
  nixos-config,
  ...
}: {
  nix.auto-update.specialisation = "graphical";
  imports = [
    "${nixos-config}/config/graphical.nix"
  ];
  home-manager.users.darkkirb = {
    # Turn off power management settings on AC power
    # This is not very useful for an installer
    programs.plasma.powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        turnOffDisplay.idleTimeout = "never";
        dimDisplay.enable = false;
        powerProfile = "performance";
      };
    };
    programs.plasma.kscreenlocker.autoLock = false;
  };
}
