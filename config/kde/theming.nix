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
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
