{
  pkgs,
  config,
  lib,
  systemConfig,
  ...
}:
{
  xdg.desktopEntries = lib.mkIf (systemConfig.networking.hostName == "rainbow-resort") {
    ff11 = {
      name = "Final Fantasy XI";
      comment = "Custom Launcher for Final Fantasy XI";
      exec = "${pkgs.coreutils}/bin/env WINEPREFIX=${config.home.homeDirectory}/Games/FF11/Wine WINEESYNC=1 WINEFSYNC=1 ${pkgs.wine-tkg}/bin/wine ${config.home.homeDirectory}/Games/FF11/Wine/drive_c/users/darkkirb/AppData/Local/HorizonXI_Launcher/HorizonXI-Launcher.exe";
      prefersNonDefaultGPU = true;
      icon = pkgs.fetchurl {
        url = "https://horizonxi.com/logo.png";
        sha256 = "1ykk9dk6vlz6hcvzjjflx5zywsw9x9ffmpz280mxggr6q94p40y7";
      };
    };
  };
}
