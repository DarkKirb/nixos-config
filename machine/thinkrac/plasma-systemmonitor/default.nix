{ ... }:
{
  xdg.dataFile."plasma-systemmonitor/thermals.page".source = ./thermals.page;
  programs.plasma.configFile.systemmonitorrc.General.pageOrder =
    "overview.page,applications.page,history.page,processes.page,thermals.page";

}
