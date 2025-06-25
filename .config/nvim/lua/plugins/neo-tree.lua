return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- 👈 show hidden files
        hide_dotfiles = false, -- 👈 show .dotfiles
        hide_gitignored = false,
      },
    },
  },
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
