{
  config,
  pkgs,
  lib,
  systemConfig,
  ...
}:
{
  config = lib.mkIf (systemConfig.networking.hostName == "rainbow-resort") {
    home.packages = with pkgs; [ xivlauncher ];
    systemd.user.tmpfiles.rules = [
      "L ${config.home.homeDirectory}/.xlcore - - - - ${config.home.homeDirectory}/Games/FF14/xlcore"
    ];
  };
}
