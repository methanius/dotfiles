return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Signs
      for _, group in pairs({
        "DapBreakpoint",
        "DapBreakpointCondition",
        "DapBreakpointRejected",
        "DapLogPoint",
      }) do
        vim.fn.sign_define(group, { text = "●", texthl = group })
      end

      local dap = require("dap")
      -- C, C++
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      require("dap.ext.vscode").load_launchjs()
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    dependencies = {
      { "stevearc/overseer.nvim",          config = true },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        lazy = false,
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} }
    },
  }
}
