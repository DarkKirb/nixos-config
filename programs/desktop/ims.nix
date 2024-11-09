{config, pkgs, ...}: {
  home.packages = with pkgs; [
    telegram-desktop
  ];
  home.persistence.default.directories = [".local/share/TelegramDesktop"];
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
    "d ${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
    "L ${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
    "L ${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
  ];
}
