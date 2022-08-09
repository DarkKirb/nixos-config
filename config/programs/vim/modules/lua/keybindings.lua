local wk = require("which-key")

wk.register({
    -- File commands
    f = {
        name = "file",

        f = { vim.lsp.buf.formatting, "Format file" },
        n = { "<cmd>new", "New File" },

        o = { require'telescope-config'.project_files, "Find File" },
        l = { require'telescope.builtin'.find_files, "Find Local File" },
        h = { require'telescope-config'.home_files, "Find Global File" },
        b = { require'telescope-config'.all_buffers, "Switch Buffer" },
        ["/"] = { "<cmd>Telescope live_grep<cr>", "Grep Project" },
    },
}, { prefix = "<leader>" })
