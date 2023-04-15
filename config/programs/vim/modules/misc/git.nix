{
  pkgs,
  config,
  ...
}: {
    # 
  output.plugins = with pkgs.vimPlugins; [
    vim-fugitive
    vim-flog
    gitlinker-nvim
    gitsigns-nvim
    committia-vim
  ];
  vim.keybindings.keybindings."<leader>".g = {
    s = {
      command = "<cmd>Git<cr>";
      label = "Git status";
    };
    w = {
      command = "<cmd>Gwrite<cr>";
      label = "Git add";
    };
    c = {
      command = "<cmd>Git commit<cr>";
      label = "Git commit";
    };
    d = {
      command = "<cmd>Gdiffsplit<cr>";
      label = "Git diff";
    };
    p = {
      l = {
        command = "<cmd>Git pull<cr>";
        label = "Git pull";
      };
      u = {
        command = "<cmd>15 split|term git push<cr>";
        label = "Git push";
      };
    };
    l = {
      command = "<cmd>lua require('gitlinker').get_buf_range_url(vim.fn.mode())<cr>";
      options.silent = true;
      mode = "";
      label = "get git permlink";
    };
    b = {
      command = "<cmd>lua require('gitlinker').get_repo_url({action_callback = require('gitlinker').actions.open_in_browser})<cr>";
      options.silent = true;
      label = "browse repo in browser";
    };
  };
  plugin.setup.gitlinker = {};
  plugin.setup.gitsigns = {
    signs = {
      add = {
        hl = "GitSignsAdd";
        text = "+";
        numhl = "GitSignsAddNr";
        linehl = "GitSignsAddLn";
      };
      change = {
        hl = "GitSignsChange";
        text = "~";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
      delete = {
        hl = "GitSignsDelete";
        text = "_";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      topdelete = {
        hl = "GitSignsDelete";
        text = "‾";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      changedelete = {
        hl = "GitSignsChange";
        text = "│";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
    };
    word_diff = true;
  };
  extraLuaModules = ["config.gitsigns"];
}
