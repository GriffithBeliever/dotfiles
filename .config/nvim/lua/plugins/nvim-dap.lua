return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text", -- optional but very nice
  },
  config = function()
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()

    local dap = require("dap")
    local dapui = require("dapui")

    -- Open UI automatically when debugging starts
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    -- Close UI when debugging ends
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        showLog = false,
        program = "${file}",
        dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
      },
    }
  end,
}
