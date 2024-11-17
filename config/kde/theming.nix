{ systemConfig, pkgs, ... }:
{
  programs.plasma = {
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaperSlideShow = {
        path = if systemConfig.isNSFW then "${pkgs.art-lotte-bgs-nsfw}" else "${pkgs.art-lotte-bgs-sfw}";
      };
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
    fonts.fixedWidth = {
      family = "FiraCode Nerd Font Mono";
      pointSize = 9;
    };
    configFile.kwinrc."NightColor" = {
      Active = true;
      LatitudeFixed = 51;
      LongitudeFixed = 13;
      Mode = "Location";
      NightTemperature = 4200;
    };
  };
}
