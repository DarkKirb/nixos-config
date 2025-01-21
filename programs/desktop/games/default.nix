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
        wineWowPackages.waylandFull
        factorio
      ])
    ];
  home.persistence.default.directories = lib.mkMerge [
    [
      ".config/ppsspp"
    ]
    (lib.mkIf (system == "x86_64-linux") [
      ".local/share/factorio"
    ])
  ];
  systemd.user.tmpfiles.rules = lib.mkMerge [
    [
      "L ${config.xdg.dataHome}/PrismLauncher - - - - ${config.home.homeDirectory}/Games/Minecraft"
    ]
    (lib.mkIf (system == "x86_64-linux") [
      "d /persistent${config.xdg.dataHome}/factorio - - - - -"
      "L ${config.home.homeDirectory}/.factorio - - - - ${config.xdg.dataHome}/factorio"
    ])
  ];
}
