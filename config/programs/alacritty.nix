{ pkgs, ... }: {
  programs.alacritty.settings = {
    #bell.command = {
    #  command = "${pkgs.libnotify}/bin/notify-send";
    #  args = "Console Bell rung";
    #};
  };
}
