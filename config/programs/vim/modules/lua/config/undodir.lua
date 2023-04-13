local home = os.getenv("HOME")

vim.opt.undodir = home .. "/.cache/nvim/undo-files//"
vim.opt.directory = home .. "/.cache/nvim/swap-files//"
vim.opt.backupdir = home .. "/.cache/nvim/backup-files//"
