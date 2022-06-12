local o = vim.o
local wo = vim.wo
local bo = vim.bo
local map = vim.api.nvim_set_keymap

o.mouse = "ar"
o.clipboard = "unnamedplus" -- The correct default clipboard
o.cmdheight = 2 -- more space for displaying messages
-- Having longer updatetime (default is 4000ms = 4s) leads to noticeable delays and poor user experience
o.updatetime = 300
-- don’t pass messages to |ins-completion-menu|
o.shortmess = o.shortmess .. "c"

wo.number = true
wo.relativenumber = true
wo.signcolumn = "number"

bo.tabstop = 2
bo.shiftwidth = 2
bo.expandtab = true

-- NerdTree config
-- Automatically open NERDTre and move to the previous window
vim.api.nvim_create_autocmd("VimEnter", {
    command = "NERDTree | wincmd p"
})
-- Close vim when NERDTree is the only window left
vim.api.nvim_create_autocmd("BufEnter", {
    command = "if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
})
-- Ban replacing NERDTree
vim.api.nvim_create_autocmd("BufEnter", {
    command = "if bufname('#') =~ 'NERD_tree_\\d\\+' && bufname('%') !~ 'NERD_tree_\\d\\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute \"normal! \\<C-W>w\" | execute 'buffer'.buf | endif"
})

-- Use NerdFonts
vim.api.nvim_set_var("NERDTreeGitStatusUseNerdFonts", 1)

-- CtrlP config
vim.api.nvim_set_var("ctrlp_map", "<c-p>")
vim.api.nvim_set_var("ctrlp_cmd", "CtrlP")

-- Tagbar config
map('n', "<F8>", ":TagbarToggle<CR>")

-- use powerline fonts
vim.api.nvim_set_var("airline_powerline_fonts", 1)
vim.api.nvim_set_var("airline_highlighting_cache", 1)

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'rust_analyzer' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
        }
    }
end
