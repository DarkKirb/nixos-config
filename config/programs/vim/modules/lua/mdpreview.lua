-- small script to automatically compile my markdown documents
-- to use put `lua require'mdpreview'.open_preview()` somewhere in your keymappings
-- TODO: Make use of vim.schedule


local M = {}
local Job = require'plenary.job'

local zathura_open = function()
    local filename = vim.fn.expand("%:r") .. ".pdf"

    Job:new({
        command = 'zathura',
        args = {filename},
        on_exit = function(j, ret_val)
            if ret_val ~= 0 then
                error("Error while viewing `" .. filename .. "`: " .. ret_val)
            end
        end,
    }):start()
end

M.markdown_compile = function()
    local filename = vim.fn.expand("%")
    local output = vim.fn.expand("%:r") .. ".pdf"
    -- local filename_with_lua = vim.api.nvim_buf_get_name(0)

    -- TODO: put non-blocking timeout on these jobs
    -- TODO: report errors (from stderr)
    Job:new({
        command = 'pandoc',
        args = {filename, "-o", output},
        on_exit = function(j, ret_val)

            if ret_val == 0 then
                print("Successfully compiled " .. filename)
            else
                print("Error while compiling " .. filename)
            end
        end,
    -- Timeout of 30 seconds
    -- }):sync(30 * 1000)
    }):start()
end

M.open_preview = function()
    vim.api.nvim_exec([[
        augroup mdpreview
            autocmd!
            au BufWritePost *.md lua require'mdpreview'.markdown_compile()
        augroup END
    ]], false)

    M.markdown_compile()
    zathura_open()
end

return M
