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
  ];
  home.persistence.default.directories = [
    ".local/share/factorio"
    ".config/ppsspp"
  ];
  systemd.user.tmpfiles.rules = [
    "d /persistent${config.xdg.dataHome}/factorio - - - - -"
    "L ${config.home.homeDirectory}/.factorio - - - - ${config.xdg.dataHome}/factorio"
  ];
}
