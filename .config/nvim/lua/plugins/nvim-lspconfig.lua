return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- optional:
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		-- Set up mason
		require("mason").setup()
		require("mason-lspconfig").setup()

		-- Define capabilities if using nvim-cmp (optional but good)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if cmp_ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		-- Shared on_attach callback
		local on_attach = function(_, bufnr)
			local map = function(mode, lhs, rhs)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
			end
			map("n", "gd", vim.lsp.buf.definition)
			map("n", "K", vim.lsp.buf.hover)
			map("n", "<leader>rn", vim.lsp.buf.rename)
			map("n", "<leader>ca", vim.lsp.buf.code_action)
		end

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format buffer" })

		local lspconfig = require("lspconfig")

		-- Lua
		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- Go
		lspconfig.gopls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		-- Rust
		lspconfig.rust_analyzer.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		-- TypeScript
		-- lspconfig.denols.setup({
		-- 	root_dir = lspconfig.util.root_pattern("deno.json"),
		-- })
		lspconfig.ts_ls.setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(client, bufnr)
				-- disable formatting to avoid conflict with prettier
				client.server_capabilities.documentFormattingProvider = false
			end,
		})
	end,
}
