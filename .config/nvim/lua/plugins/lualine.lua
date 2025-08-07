-- the opts function can also be used to change the default opts:
local status = require("gitsync.status")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts = opts or {}

    -- Initialize sections if missing
    opts.sections = opts.sections or {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

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

