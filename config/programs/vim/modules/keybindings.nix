{
  vim.keybindings = {
    leader = " ";
    which-key-nvim = true;

    # Documented keybindings accessible via SPC
    keybindings."<leader>" = {

      ### LaTeX commands
      l = {
        # name = "LaTeX";

        l = {
          command = "<cmd>VimtexCompile<cr>";
          label = "Compile";
        };
        c = {
          command = "<cmd>VimtexCountWords<cr>";
          label = "Count Words";
        };
        e = {
          command = "<cmd>VimtexErrors<cr>";
          label = "Open Errors";
        };
        v = {
          command = "<cmd>VimtexView<cr>";
          label = "View";
        };
        p = {
          command = "<cmd>lua require'mdpreview'.open_preview()<cr>";
          label = "Pandoc View";
        };
      };


      ### Git commands
      v = {
        # name = "git";

        v = {
          command = "<cmd>Telescope git_bcommits<cr>";
          label = "Buffer Commits";
        };
        h = {
          command = "<cmd>Telescope git_commits<cr>";
          label = "Commits";
        };

        b = {
          command = "<cmd>Telescope git_branches<cr>";
          label = "Branches";
        };
        s = {
          command = "<cmd>Telescope git_status<cr>";
          label = "Status";
        };
      };

      ### Documentation commands
      d = {
        # name = "docs";

        v = {
          command = "<cmd>Telescope help_tags<cr>";
          label = "Vim";
        };
        m = {
          command = "<cmd>Telescope man_pages<cr>";
          label = "Man";
        };
      };

      ### Miscellaneous
      ";" = {
        mode = "";
        command = "<Plug>NERDCommenterToggle";
        label = "Toggle Comment";
      };
    };

    # Quick and dirty general keybindings
    keybindings-shortened = {
      k = { command = "gk"; };
      j = { command = "gj"; };
      "0" = { command = "g0"; };
      "$" = { command = "g$"; };
    };

  };
}
