vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
	vim.defer_fn(function()
	    require("copilot").setup()
	end, 100)
    end 
})
