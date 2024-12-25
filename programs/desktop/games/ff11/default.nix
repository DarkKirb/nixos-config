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
      exec = "${lib.getExe' pkgs.coreutils "env"} WINEPREFIX=${config.home.homeDirectory}/Games/FF11/Wine WINEESYNC=1 WINEFSYNC=1 ${lib.getExe pkgs.wine-ge} C:\\\\\\\\users\\\\\\\\darkkirb\\\\\\\\AppData\\\\\\\\Roaming\\\\\\\\Microsoft\\\\\\\\Windows\\\\\\\\Start\\\\ Menu\\\\\\\\Programs\\\\\\\\HorizonXI\\\\\\\\HorizonXI-Launcher.lnk";
      prefersNonDefaultGPU = true;
      icon = pkgs.fetchurl {
        url = "https://horizonxi.com/logo.png";
        sha256 = "1ykk9dk6vlz6hcvzjjflx5zywsw9x9ffmpz280mxggr6q94p40y7";
      };
    };
  };
}
