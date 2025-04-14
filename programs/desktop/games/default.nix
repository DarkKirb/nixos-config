{
  pkgs,
  config,
  system,
  lib,
  ...
}:
{
  imports = [
    ./ff14
  ];
  home.packages =
    with pkgs;
    (lib.mkIf (system == "x86_64-linux") [
      prismlauncher
      wineWowPackages.full
      winetricks
      (bolt-launcher.override {
        enableRS3 = true;
      })
    ]);
  home.persistence.default.directories = lib.mkMerge [
    (lib.mkIf (system == "x86_64-linux") [
      ".local/share/bolt-launcher"
      ".config/bolt-launcher"
    ])
  ];
  systemd.user.tmpfiles.rules = (
    lib.mkIf (system == "x86_64-linux") [
      "L ${config.xdg.dataHome}/PrismLauncher - - - - ${config.home.homeDirectory}/Games/Minecraft"
      "d /persistent${config.xdg.cacheHome}/bolt-launcher/CefCache - - - - -"
      "L ${config.xdg.dataHome}/bolt-launcher/CefCache - - - - ${config.xdg.cacheHome}/bolt-launcher/CefCache"
    ]
  );
}
