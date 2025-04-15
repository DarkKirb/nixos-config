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
        nheko
        kdePackages.tokodon
      ]
      (lib.mkIf withElectron [
        teams-for-linux
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    [
      ".config/nheko"
      ".local/share/nheko"
      ".local/share/KDE/tokodon"
    ]
    (lib.mkIf withElectron [
      ".local/share/teams-for-linux"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    (lib.mkIf withElectron [
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
    ])
    (lib.mkIf (!systemConfig.system.isIntelGPU && withElectron) [
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/teams-for-linux/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/GPUCache - - - - ${config.xdg.cacheHome}/teams-for-linux/GPUCache"
    ])
    (lib.mkIf (systemConfig.system.isIntelGPU && withElectron) [
      "d /tmp${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/teams-for-linux/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/teams-for-linux/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/teams-for-linux/GPUCache - - - - /tmp${config.xdg.cacheHome}/teams-for-linux/GPUCache"
    ])
  ];
}
