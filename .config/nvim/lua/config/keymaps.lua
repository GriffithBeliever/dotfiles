-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Telescope Go to Definition" })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>fw", require("telescope.builtin").live_grep, { desc = "Live Grep" })
-- Debug Controls
map("n", "<leader>dc", function()
  require("dap").continue()
end, opts) -- d = debug, c = continue
map("n", "<leader>dn", function()
  require("dap").step_over()
end, opts) -- d = debug, n = next
map("n", "<leader>di", function()
  require("dap").step_into()
end, opts) -- d = debug, i = into
map("n", "<leader>do", function()
  require("dap").step_out()
end, opts) -- d = debug, o = out
map("n", "<leader>dq", function()
  require("dap").terminate()
end, opts) -- d = debug, q = quit

-- Breakpoints
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, opts) -- d = debug, b = breakpoint
map("n", "<leader>dB", function()
  vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
    if cond then
      require("dap").set_breakpoint(cond)
    end
  end)
end, opts)

-- REPL / UI
map("n", "<leader>dr", function()
  require("dap").repl.open()
end, opts) -- d = debug, r = repl
map("n", "<leader>du", function()
  require("dapui").toggle()
end, opts) -- d = debug, u = UI
