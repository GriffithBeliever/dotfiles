-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.number = true
vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.diagnostic.config({ overflow = { mode = "wrap" } })

vim.opt.clipboard = "unnamedplus"

