{
  config,
  pkgs,
  lib,
  systemConfig,
  system,
  ...
}:
let
  withElectron = system == "x86_64-linux";
in
{
  home.packages =
    with pkgs;
    lib.mkMerge [
      [
        telegram-desktop
        nheko
        kdePackages.tokodon
      ]
      (lib.mkIf withElectron [
        discord
        betterdiscordctl
        signal-desktop
        teams-for-linux
        element-desktop
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    [
      ".local/share/TelegramDesktop"
      ".config/nheko"
      ".local/share/nheko"
      ".local/share/KDE/tokodon"
    ]
    (lib.mkIf withElectron [
      ".local/share/discord"
      ".local/share/Signal"
      ".local/share/teams-for-linux"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    [
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
    ]
    (lib.mkIf withElectron [
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
      "d /persistent${config.xdg.cacheHome}/Signal - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/Code\\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/component_crx_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.dataHome}/Signal - - - - -"
      "L /persistent${config.xdg.dataHome}/Signal/Cache - - - - ${config.xdg.cacheHome}/Signal/Cache"
      "L /persistent${config.xdg.dataHome}/Signal/Code\\x20Cache - - - - ${config.xdg.cacheHome}/Signal/Code\\x20Cache"
      "L /persistent${config.xdg.dataHome}/Signal/component_crx_cache - - - - ${config.xdg.cacheHome}/Signal/component_crx_cache"
      "L /persistent${config.xdg.dataHome}/Signal/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/Signal/DawnGraphiteCache"
      "L /persistent${config.xdg.dataHome}/Signal/userDataCache.json - - - - ${config.xdg.cacheHome}/Signal/userDataCache.json"
      "L ${config.xdg.configHome}/Signal - - - - ${config.xdg.dataHome}/Signal"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/Code\\x20Cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/component_crx_cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/DawnGraphiteCache - - - - -"
      "d /persistent${config.xdg.dataHome}/teams-for-linux - - - - -"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/Cache - - - - ${config.xdg.cacheHome}/teams-for-linux/Cache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/Code\\x20Cache - - - - ${config.xdg.cacheHome}/teams-for-linux/Code\\x20Cache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/component_crx_cache - - - - ${config.xdg.cacheHome}/teams-for-linux/component_crx_cache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/teams-for-linux/DawnGraphiteCache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/userDataCache.json - - - - ${config.xdg.cacheHome}/teams-for-linux/userDataCache.json"
      "L ${config.xdg.configHome}/teams-for-linux - - - - ${config.xdg.dataHome}/teams-for-linux"
      "d /persistent${config.xdg.dataHome}/Element - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/Cache - - - - ${config.xdg.cacheHome}/Element/Cache"
      "L /persistent${config.xdg.dataHome}/Element/Code\\x20Cache - - - - ${config.xdg.cacheHome}/Element/Code\\x20Cache"
      "L /persistent${config.xdg.dataHome}/Element/component_crx_cache - - - - ${config.xdg.cacheHome}/Element/component_crx_cache"
      "L /persistent${config.xdg.dataHome}/Element/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/Element/DawnGraphiteCache"
      "L /persistent${config.xdg.dataHome}/Element/userDataCache.json - - - - ${config.xdg.cacheHome}/Element/userDataCache.json"
      "L ${config.xdg.configHome}/Element - - - - ${config.xdg.dataHome}/Element"
    ])
    (lib.mkIf (!systemConfig.system.isIntelGPU && withElectron) [
      "d /persistent${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - ${config.xdg.cacheHome}/discord/GPUCache"
      "d /persistent${config.xdg.cacheHome}/Signal/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Signal/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Signal/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Signal/GPUCache - - - - ${config.xdg.cacheHome}/Signal/GPUCache"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/GPUCache - - - - ${config.xdg.cacheHome}/teams-for-linux/GPUCache"
      "d /persistent${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - ${config.xdg.cacheHome}/Element/GPUCache"
    ])
    (lib.mkIf (systemConfig.system.isIntelGPU && withElectron) [
      "d /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - /tmp${config.xdg.cacheHome}/discord/GPUCache"
      "d /tmp${config.xdg.cacheHome}/Signal/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Signal/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Signal/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Signal/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Signal/GPUCache - - - - /tmp${config.xdg.cacheHome}/Signal/GPUCache"
      "d /tmp${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/teams-for-linux/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/GPUCache - - - - /tmp${config.xdg.cacheHome}/teams-for-linux/GPUCache"
      "d /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - /tmp${config.xdg.cacheHome}/Element/GPUCache"
    ])
  ];
  systemd.user.services.betterdiscord = lib.mkIf withElectron {
    Unit = {
      Description = "Patch discord";
      After = [ "graphical-session.target" ];
      PartOf = [ "home-manager-activation.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = pkgs.writeScript "install-betterdiscord" ''
        #!${lib.getExe pkgs.bash}
        ${lib.getExe pkgs.betterdiscordctl} reinstall || ${lib.getExe pkgs.betterdiscordctl} install
      '';
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
