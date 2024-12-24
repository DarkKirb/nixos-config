{ pkgs, config, ... }:
{
  imports = [
    ./ff11
    ./ff14
  ];
  home.packages = with pkgs; [
    factorio
    wine-tkg
    ppsspp
    prismlauncher
  ];
  home.persistence.default.directories = [
    ".local/share/factorio"
    ".config/ppsspp"
  ];
  systemd.user.tmpfiles.rules = [
    "d /persistent${config.xdg.dataHome}/factorio - - - - -"
    "L ${config.home.homeDirectory}/.factorio - - - - ${config.xdg.dataHome}/factorio"
    "L ${config.xdg.dataHome}/PrismLauncher - - - - ${config.home.homeDirectory}/Games/Minecraft"
  ];
}
