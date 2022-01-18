{ ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = /home/darkkirb/Music;
  };
  programs.ncmpcpp.enable = true;
}
