_: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/darkkirb/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire"
      }
      replaygain          "track"
    '';
  };
  programs.ncmpcpp.enable = true;
}
