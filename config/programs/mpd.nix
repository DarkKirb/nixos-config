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
      volume_normalization "yes"
      max_playlist_length 1048576
      max_command_list_size 1048576
      max_output_buffer_size 1048576
      auto_update yes
    '';
  };
  programs.ncmpcpp.enable = true;
}
