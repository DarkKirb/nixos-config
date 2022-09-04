local n = require("null-ls")

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local FORMATTING = methods.internal.FORMATTING

n.setup({
	sources = {
		n.builtins.formatting.stylua,
		n.builtins.formatting.rustfmt,
		n.builtins.formatting.nixfmt,
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/640
		n.builtins.formatting.black.with({ args = { "--quiet", "-" } }),
	},
})

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
end
