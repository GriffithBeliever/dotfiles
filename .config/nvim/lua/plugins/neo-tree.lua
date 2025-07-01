return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- 👈 show hidden files
        hide_dotfiles = false, -- 👈 show .dotfiles
        hide_gitignored = false,
      },
    },
  },
  lazy = false,
  keys = {
    -- remap <leader>e to toggle neo-tree instead of mini.files
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "NeoTree (cwd)",
    },
    -- Optional: disable the default LazyVim snack explorer keybinding
    {
      "<leader>fe",
      false,
    },
  },
}
