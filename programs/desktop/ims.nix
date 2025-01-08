{
  config,
  pkgs,
  lib,
  systemConfig,
  system,
  ...
}:
let
  withDiscord = system == "x86_64-linux";
in
{
  home.packages =
    with pkgs;
    lib.mkMerge [
      [
        telegram-desktop
        element-desktop
      ]
      (lib.mkIf withDiscord [
        discord
        betterdiscordctl
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    [
      ".local/share/TelegramDesktop"
      ".local/share/Element"
    ]
    (lib.mkIf withDiscord [ ".local/share/discord" ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    [
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/Code\\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.dataHome}/Element - - - - -"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
      "L /persistent${config.xdg.dataHome}/Element/Cache - - - - ${config.xdg.cacheHome}/Element/Cache"
      "L /persistent${config.xdg.dataHome}/Element/Code\\x20Cache - - - - ${config.xdg.cacheHome}/Element/Code\\x20Cache"
      "L /persistent${config.xdg.dataHome}/Element/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/Element/DawnGraphiteCache"
      "L ${config.xdg.configHome}/Element - - - - ${config.xdg.dataHome}/Element"
    ]
    (lib.mkIf withDiscord [
      "d /persistent${config.xdg.cacheHome}/discord - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/Code\\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/component_crx_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.dataHome}/discord - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/Cache - - - - ${config.xdg.cacheHome}/discord/Cache"
      "L /persistent${config.xdg.dataHome}/discord/Code\\x20Cache - - - - ${config.xdg.cacheHome}/discord/Code\\x20Cache"
      "L /persistent${config.xdg.dataHome}/discord/component_crx_cache - - - - ${config.xdg.cacheHome}/discord/component_crx_cache"
      "L /persistent${config.xdg.dataHome}/discord/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/discord/DawnGraphiteCache"
      "L /persistent${config.xdg.dataHome}/discord/userDataCache.json - - - - ${config.xdg.cacheHome}/discord/userDataCache.json"
      "L ${config.xdg.configHome}/discord - - - - ${config.xdg.dataHome}/discord"
    ])
    # GPU Cache sometimes breaks for electron apps on intel, so only persist that on non-intel
    (lib.mkIf (!systemConfig.isIntelGPU) [
      "d /persistent${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - ${config.xdg.cacheHome}/Element/GPUCache"
    ])
    (lib.mkIf (!systemConfig.isIntelGPU && withDiscord) [
      "d /persistent${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - ${config.xdg.cacheHome}/discord/GPUCache"
    ])
    (lib.mkIf (systemConfig.isIntelGPU) [
      "d /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Element/GPUCache - - - - -"

      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - /tmp${config.xdg.cacheHome}/Element/GPUCache"
    ])
    (lib.mkIf (systemConfig.isIntelGPU && withDiscord) [
      "d /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - /tmp${config.xdg.cacheHome}/discord/GPUCache"
    ])
  ];
  systemd.user.services.betterdiscord = lib.mkIf withDiscord {
    Unit = {
      Description = "Patch discord";
      After = [ "graphical-session.target" ];
      PartOf = [ "home-manager-activation.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${lib.getExe pkgs.betterdiscordctl} reinstall";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
