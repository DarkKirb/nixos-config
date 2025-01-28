{
  config,
  pkgs,
  lib,
  systemConfig,
  system,
  ...
}:
let
  withElectronAndTg = system == "x86_64-linux";
in
{
  home.packages =
    with pkgs;
    lib.mkMerge [
      (lib.mkIf withElectronAndTg [
        telegram-desktop
        discord
        betterdiscordctl
        signal-desktop
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    (lib.mkIf withElectronAndTg [
      ".local/share/discord"
      ".local/share/TelegramDesktop"
      ".local/share/Signal"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    (lib.mkIf withElectronAndTg [
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/cache - - - - -"
      "d /persistent${config.xdg.cacheHome}/TelegramDesktop/media_cache - - - - -"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/cache"
      "L /persistent${config.xdg.dataHome}/TelegramDesktop/tdata/user_data/media_cache - - - - ${config.xdg.cacheHome}/TelegramDesktop/media_cache"
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
    ])
    (lib.mkIf (!systemConfig.isIntelGPU && withElectronAndTg) [
      "d /persistent${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - ${config.xdg.cacheHome}/discord/GPUCache"
      "d /persistent${config.xdg.cacheHome}/Signal/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Signal/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Signal/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Signal/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Signal/GPUCache - - - - ${config.xdg.cacheHome}/Signal/GPUCache"
    ])
    (lib.mkIf (systemConfig.isIntelGPU && withElectronAndTg) [
      "d /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - /tmp${config.xdg.cacheHome}/discord/GPUCache"
      "d /tmp${config.xdg.cacheHome}/Signal/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Signal/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Signal/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Signal/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Signal/GPUCache - - - - /tmp${config.xdg.cacheHome}/Signal/GPUCache"
    ])
  ];
  systemd.user.services.betterdiscord = lib.mkIf withElectronAndTg {
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
