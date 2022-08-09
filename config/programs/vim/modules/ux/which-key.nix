{ pkgs, ... }:

{
  vim.keybindings.which-key-nvim = true;

  plugin.setup.which-key = {
    # Only start which-key.nvim for these keys
    # I was getting sick and tired of it opening on random operators...
    triggers = [ "<leader>" "g" "z" "<C-w>" "\"" ];
  };
}
