-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Telescope Go to Definition" })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<F5>", function()
  require("dap").continue()
end, opts)
map("n", "<F10>", function()
  require("dap").step_over()
end, opts)
map("n", "<F11>", function()
  require("dap").step_into()
end, opts)
map("n", "<F12>", function()
  require("dap").step_out()
end, opts)
map("n", "<leader>tb", function()
  require("dap").toggle_breakpoint()
end, opts)
map("n", "<leader>tdr", function()
  require("dap").repl.open()
end, opts)
map("n", "<leader>tdl", function()
  require("dapui").toggle()
end, opts)
