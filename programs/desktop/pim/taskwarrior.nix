{ pkgs, config, ... }:
{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    dataLocation = "${config.home.homeDirectory}/Data/tasks";
  };
}
