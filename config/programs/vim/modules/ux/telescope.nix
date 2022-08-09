{ pkgs, ... }:

{
  output.extraConfig = ''
    lua <<EOF

    local actions = require('telescope.actions')
    require('telescope').setup{
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close
          },
        },
      }
    }

    EOF
  '';

    output.path.path = with pkgs; [ fd ripgrep ];
    output.plugins = with pkgs.vimPlugins; [ telescope-nvim ];
}
