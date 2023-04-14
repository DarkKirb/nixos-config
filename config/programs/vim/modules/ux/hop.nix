{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [hop-nvim];
  plugin.setup.hop = {
    case_insensitive = true;
    char2_fallback_key = "<CR>";
    quit_key = "<Etc>";
  };

  vim.keybindings.keybindings.f = {
    command = "<cmd>lua require('hop').hint_char2()<cr>";
    options.silent = true;
    label = "nvim-hop char2";
    mode = "";
  };
}
