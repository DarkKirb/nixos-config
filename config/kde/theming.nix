{ systemConfig, ... }:
{
  programs.plasma = {
    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };
    panels = [
      # Windows-like panel at the bottom
      {
        location = if systemConfig.networking.hostname == "stinky-ssb" then "right" else "bottom";
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
