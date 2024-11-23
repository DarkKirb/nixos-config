{ ... }:
{
  programs.plasma = {
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };
    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        screen = "all";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.pager"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Global menu at the top
      {
        location = "top";
        height = 26;
        widgets = [ "org.kde.plasma.appmenu" ];
        screen = "all";
      }
    ];
    configFile.kwinrc."NightColor" = {
      Active = true;
      LatitudeFixed = 51;
      LongitudeFixed = 13;
      Mode = "Location";
      NightTemperature = 4200;
    };
  };
}
