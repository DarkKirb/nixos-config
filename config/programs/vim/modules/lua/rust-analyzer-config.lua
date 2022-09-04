local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
					extraArgs = {
						"--",
						"-W clippy::cargo",
						"-W clippy::pedantic",
						"-W clippy::allow_attributes_without_reason",
						"-W clippy::clone_on_ref_ptr",
						"-W clippy::create_dir",
						"-W clippy::decimal_literal_representation",
						"-D unsafe_code",
						"-W clippy::deref_by_slicing",
						"-W clippy::empty_drop",
						"-W clippy::empty_structs_with_brackets",
						"-W clippy::exhaustive_enums",
						"-W clippy::exit",
						"-W clippy::expect_used",
						"-W clippy::panic",
						"-W clippy::filetype_is_file",
						"-W clippy::float_cmp_const",
						"-D clippy::fn_to_numeric_cast_any",
						"-W clippy::format_push_string",
						"-W clippy::if_then_some_else_none",
						"-W clippy::let_underscore_must_use",
						"-W clippy::lossy_float_literal",
						"-W clippy::map_err_ignore",
						"-W clippy::mem_forget",
						"-W missing_docs",
						"-W clippy::missing_docs_in_private_items",
						"-W clippy::mixed_read_write_in_expression",
						"-W clippy::rc_buffer",
						"-D clippy::rc_mutex",
						"-W clippy::str_to_string",
						"-W clippy::string_add",
						"-W clippy::string_to_string",
						"-W clippy::try_err",
						"-D clippy::unwrap_used",
						"-W clippy::nursery",
					},
				},
				hover = {
					actions = {
						references = {
							enable = true,
						},
					},
				},
				imports = {
					granularity = {
						enforce = true,
					},
				},
			},
		},
	},
})
