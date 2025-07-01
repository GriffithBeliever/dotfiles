-- the opts function can also be used to change the default opts:
local status = require("gitsync.status")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      function()
        return status.get_dot() .. " " .. (status.connected and "connected to remote" or "disconnected")
      end,
      color = function(section)
        return { fg = status.connected and "Green" or "#aa3355" }
      end,
    })
    -- table.insert(opts.sections.lualine_x, {
    --   function()
    --     return "Hello World"
    --   end,
    -- })
  end,
}

-- -- or you can return new options to override all the defaults
-- {
--   "nvim-lualine/lualine.nvim",
--   event = "VeryLazy",
--   opts = function()
--     return {
--       --[[add your custom lualine config here]]
--     }
--   end,
-- },
--
