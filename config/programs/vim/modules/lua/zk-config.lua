require("zk").setup({
  picker = "telescope",
  lsp = {
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
    }
  },
  auto_attach = {
    enabled = true,
    filetypes = { "markdown" },
  }
})
-- TODO: nvim-nix does not support multiple keybindings in different modes yet

vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", { noremap = true, silent = false })
require("which-key").register({
  z = {
    name = "Zettelkasten"
  }
}, { prefix = "<leader>" })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
    if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
      local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
      local opts = { noremap=true, silent=false }

      -- Open the link under the caret.
      map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

      -- Create a new note after asking for its title.
      -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
      map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
      -- Create a new note in the same directory as the current buffer, using the current selection for title.
      map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)
      -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
      map("v", "<leader>znc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)

      -- Open notes linking to the current buffer.
      map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
      -- Alternative for backlinks using pure LSP and showing the source context.
      --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
      -- Open notes linked by the current buffer.
      map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

      -- Preview a linked note.
      map("n", "<leader>zp", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
      -- Open the code actions for a visual selection.
      map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
      require("which-key").register({
        z = {
          n = {
            name = "New"
            t = "New note with title from selection"
            c = "New note with content from selection"
          },
          b = "Open backlinks",
          l = "Open links",
          p = "Preview linked note",
          a = "Open code actions"
        }
      }, { prefix = "<leader>" })
    end
  end
})
