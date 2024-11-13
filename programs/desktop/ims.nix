{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
  ];
  home.persistence.default.directories = [ ".local/share/TelegramDesktop" ];
  systemd.user.tmpfiles.rules = [
    "d /persistent${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
    "d /persistent${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
    "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
    "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
  ];
}
