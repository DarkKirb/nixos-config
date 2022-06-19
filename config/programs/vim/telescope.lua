require("telescope").setup {
    ["ui-select"] = {
	require("telescope.themes").get_dropdown {
	}
    }
}

require("telescope").load_extension("ui-select")
