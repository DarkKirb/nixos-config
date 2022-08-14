{ pkgs, ... }: {
  output.plugins = with pkgs.vimPlugins; [zk-nvim];
  output.config_file = ''
    lua require("zk-config")
    '';
    vim.keybindings = {
      keybindings = {
        "<leader>".z = {
          n = {
            command = "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>";
            label = "Create new Zettel";
          };
          o = {
            command = "<Cmd>ZkNotes { sort = { 'modified' } }<CR>";
            label = "Open Zettel";
          };
          t = {
            command = "<Cmd>ZkTags<CR>";
            label = "Open Zettel associated with selected tags";
          };
          f = {
            command = "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>";
            label = "Search for Zettel given a given query";
          };

        };
      };
    };
}
