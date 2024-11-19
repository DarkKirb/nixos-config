{ plasma-manager, ... }:
{
  programs.plasma.enable = true;
  programs.plasma.configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
    ./theming.nix
    ./krdp.nix
    ./gtk-fixes
  ];
  programs.plasma.kwin.virtualDesktops = {
    rows = 3;
    number = 9;
  };
}
