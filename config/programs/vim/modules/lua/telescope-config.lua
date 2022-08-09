local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

M.home_files = function()
    require'telescope.builtin'.find_files({
        search_dirs = { "~/Literatuur", "~/Documents", "/etc/nixos", "~/.config" },
    })
end

M.all_buffers = function()
    require'telescope.builtin'.buffers({
        show_all_buffers = true,
        only_cwd = false,
        sort_lastused = true,
    })
end

return M
