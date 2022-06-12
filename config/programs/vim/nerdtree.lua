-- Automatically open NERDTree and move to the previous window
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
