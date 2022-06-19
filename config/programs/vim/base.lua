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

bo.tabstop = 2
bo.shiftwidth = 2
bo.expandtab = true
