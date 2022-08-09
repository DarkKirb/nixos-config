{ pkgs, ... }:

{
  plugin.setup.gitsigns = {
    # Disable default keybindings
    keymaps = {};
  };

  output.plugins = with pkgs.vimPlugins; [ gitsigns-nvim ];
  output.path.path = with pkgs; [ git ];
}
