local gs = require("gitsigns")

local function map(mode, l, r, opts)
    opts = opts or {}
    vim.keymap.set(mode, l, r, opts)
end

-- Navigation
map("n", "]c", function()
    if vim.wo.diff then
        return "]c"
    end
    vim.schedule(function()
        gs.next_hunk()
    end)
    return "<Ignore>"
end, { expr = true, desc = "next hunk" })

map("n", "[c", function()
    if vim.wo.diff then
        return "[c"
    end
    vim.schedule(function()
        gs.prev_hunk()
    end)
    return "<Ignore>"
end, { expr = true, desc = "previous hunk" })

-- Actions
map("n", "<leader>hp", gs.preview_hunk)
map("n", "<leader>hb", function()
    gs.blame_line { full = true }
end)
