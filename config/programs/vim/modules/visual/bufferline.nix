{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [bufferline-nvim];
  plugin.setup.bufferline = {
    options = {
      numbers = "buffer_id";
      close_command = "bdelete! %d";
      left_mouse_command = "buffer %d";
      indicator = {
        icon = "▎"; # this should be omitted if indicator style is not 'icon'
        style = "icon";
      };
      buffer_close_icon = "";
      modified_icon = "●";
      close_icon = "";
      left_trunc_marker = "";
      right_trunc_marker = "";
      max_name_length = 18;
      max_prefix_length = 15;
      tab_size = 10;
      diagnostics = false;
      show_buffer_icons = false;
      show_buffer_close_icons = true;
      show_close_icon = true;
      show_tab_indicators = true;
      persist_buffer_sort = true; # whether or not custom sorted buffers should persist
      separator_style = "bar";
      enforce_regular_tabs = false;
      always_show_bufferline = true;
      sort_by = "id";
    };
  };
}
