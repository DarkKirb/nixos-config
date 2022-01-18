{ ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "$HOME/music";
  };
  programs.ncmpcpp.enable = true;
}
