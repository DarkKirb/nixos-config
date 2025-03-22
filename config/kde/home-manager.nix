{ plasma-manager, ... }:
{
  programs.plasma.enable = true;
  programs.plasma.configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;
  programs.plasma.configFile.kwalletrc."org.freedesktop.secrets".apiEnabled = false;
  programs.plasma.configFile.kwalletrc.Wallet.Enabled = false;
  programs.plasma.configFile.spectaclerc = {
    General.autoSaveImage = true;
    General.launchAction = "UseLastUsedCapturemode";
  };
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
    ./theming.nix
    ./krdp.nix
    ./konsole.nix
  ];
  programs.plasma.kwin.virtualDesktops = {
    rows = 3;
    number = 9;
  };
}
