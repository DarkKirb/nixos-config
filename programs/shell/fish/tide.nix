{...}: {
  programs.fish.plugins = with pkgs.fishPlugins; [
    {
      name = "tide";
      src = tide.src;
    }
  ];
  programs.fish.shellInit = ''
    tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Round --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, frame' --prompt_connection=Dotted --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Light --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
  '';
}
