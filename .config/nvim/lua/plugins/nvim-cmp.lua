return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP completion source
			"L3MON4D3/LuaSnip", -- Snippet engine (optional but recommended)
			"saadparwaiz1/cmp_luasnip" -- Snippet completions
		},
		config = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done()
			)

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(), -- manual trigger
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{
						name = "nvim_lsp",
						entry_filter = function (entry)
							-- Filter out snippets from LSP to avoidduplicates
							return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Snippet
						end,

					},
					{ name = "luasnip" },
				},
			})
		end,
	},
}
