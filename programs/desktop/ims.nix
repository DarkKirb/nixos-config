{
  config,
  pkgs,
  lib,
  systemConfig,
  ...
}:
{
  home.packages = with pkgs; [
    telegram-desktop
    discord
    element-desktop
  ];
  home.persistence.default.directories = [
    ".local/share/TelegramDesktop"
    ".local/share/discord"
    ".local/share/Element"
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    [
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/Code\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/component_crx_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/Code\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.dataHome}/discord - - - - -"
      "d /persistent${config.xdg.dataHome}/Element - - - - -"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
      "L /persistent${config.xdg.dataHome}/discord/Cache - - - - ${config.xdg.cacheHome}/discord/Cache"
      "L /persistent${config.xdg.dataHome}/discord/Code\x20Cache - - - - ${config.xdg.cacheHome}/discord/Code\x20Cache"
      "L /persistent${config.xdg.dataHome}/discord/component_crx_cache - - - - ${config.xdg.cacheHome}/discord/component_crx_cache"
      "L /persistent${config.xdg.dataHome}/discord/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/discord/DawnGraphiteCache"
      "L /persistent${config.xdg.dataHome}/discord/userDataCache.json - - - - ${config.xdg.cacheHome}/discord/userDataCache.json"
      "L /persistent${config.xdg.dataHome}/Element/Cache - - - - ${config.xdg.cacheHome}/Element/Cache"
      "L /persistent${config.xdg.dataHome}/Element/Code\x20Cache - - - - ${config.xdg.cacheHome}/Element/Code\x20Cache"
      "L /persistent${config.xdg.dataHome}/Element/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/Element/DawnGraphiteCache"
      "L ${config.xdg.configHome}/discord - - - - ${config.xdg.dataHome}/discord"
      "L ${config.xdg.configHome}/Element - - - - ${config.xdg.dataHome}/Element"
    ]
    # GPU Cache sometimes breaks for electron apps on intel, so only persist that on non-intel
    (lib.mkIf (!systemConfig.isIntelGPU) [
      "d /persistent${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - ${config.xdg.cacheHome}/discord/GPUCache"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - ${config.xdg.cacheHome}/Element/GPUCache"

    ])
    (lib.mkIf (systemConfig.isIntelGPU) [
      "d /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - /tmp${config.xdg.cacheHome}/discord/GPUCache"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - /tmp${config.xdg.cacheHome}/Element/GPUCache"
    ])
  ];
}
