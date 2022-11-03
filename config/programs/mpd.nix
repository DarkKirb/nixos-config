_: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/darkkirb/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire"
      }
    '';
  };
  programs.ncmpcpp.enable = true;
}
