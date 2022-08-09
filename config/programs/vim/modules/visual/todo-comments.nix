{ pkgs, ... }:

{
  vim.keybindings.keybindings-shortened = {
    "<leader>gt" = { command = "<cmd>TodoTelescope<cr>"; };
  };

  plugin.setup.todo-comments = {};

  output.plugins = with pkgs.vimPlugins; [ todo-comments-nvim ];
}
