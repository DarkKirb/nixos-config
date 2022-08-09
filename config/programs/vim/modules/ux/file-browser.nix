{
  pkgs,
  lib,
  config,
  ...
}: {
  vim.keybindings.keybindings-shortened."<leader>fk" = {
    command = ":lua require'telescope'.extensions.file_browser.file_browser(require'telescope.themes'.get_ivy({ initial_mode = 'normal', default_selection_index = 2, }))<CR>";
    label = "Browse Files";
  };

  output.extraConfig = ''
    lua << EOF
      local tele = require'telescope'
      local fba = tele.extensions.file_browser.actions
      local tla = require'telescope.actions'

      tele.setup {
        extensions = {
          file_browser = {
            mappings = {
              ["n"] = {
                  ["h"] = fba.goto_parent_dir,
                  ["l"] = tla.select_default,
                  ["e"] = tla.select_default,

                  -- Misc
                  ["zh"] = fba.toggle_hidden,
                  ["~"] = fba.goto_home_dir,
                  ["`"] = fba.goto_cwd,
                  ["="] = fba.change_cwd,
              },
            }
          }
        }
      }

      tele.load_extension("file_browser")
    EOF
  '';

  output.plugins = [
    pkgs.telescope-file-browser-nvim
  ];
}
