{
  pkgs,
  config,
  system,
  lib,
  ...
}:
{
  imports = [
    ./ff11
    ./ff14
  ];
  home.packages =
    with pkgs;
    lib.mkMerge [
      [
        ppsspp
        prismlauncher
      ]
      (lib.mkIf (system == "x86_64-linux") [
        wineWowPackages.full
        winetricks
        factorio
        (bolt-launcher.override {
          enableRS3 = true;
        })
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    [
      ".config/ppsspp"
    ]
    (lib.mkIf (system == "x86_64-linux") [
      ".local/share/factorio"
      ".local/share/bolt-launcher"
      ".config/bolt-launcher"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    [
      "L ${config.xdg.dataHome}/PrismLauncher - - - - ${config.home.homeDirectory}/Games/Minecraft"
    ]
    (lib.mkIf (system == "x86_64-linux") [
      "d /persistent${config.xdg.dataHome}/factorio - - - - -"
      "L ${config.home.homeDirectory}/.factorio - - - - ${config.xdg.dataHome}/factorio"
      "d /persistent${config.xdg.cacheHome}/bolt-launcher/CefCache - - - - -"
      "L ${config.xdg.dataHome}/bolt-launcher/CefCache - - - - ${config.xdg.cacheHome}/bolt-launcher/CefCache"
    ])
  ];
}
