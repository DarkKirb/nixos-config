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
        element-desktop
        discord
        betterdiscordctl
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    (lib.mkIf withElectronAndTg [
      ".local/share/discord"
      ".local/share/TelegramDesktop"
      ".local/share/Element"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    (lib.mkIf withElectronAndTg [
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
    (lib.mkIf (!systemConfig.isIntelGPU && withElectronAndTg) [
      "d /persistent${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - ${config.xdg.cacheHome}/Element/GPUCache"
      "d /persistent${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /persistent${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - ${config.xdg.cacheHome}/discord/GPUCache"
    ])
    (lib.mkIf (systemConfig.isIntelGPU && withElectronAndTg) [
      "d /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/Element/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/Element/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Element/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/Element/GPUCache - - - - /tmp${config.xdg.cacheHome}/Element/GPUCache"
      "d /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache - - - - -"
      "d /tmp${config.xdg.cacheHome}/discord/GPUCache - - - - -"
      "L /persistent${config.xdg.dataHome}/discord/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/discord/DawnWebGPUCache"
      "L /persistent${config.xdg.dataHome}/discord/GPUCache - - - - /tmp${config.xdg.cacheHome}/discord/GPUCache"
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
