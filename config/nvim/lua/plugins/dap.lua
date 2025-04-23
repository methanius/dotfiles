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
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "DAP Breakpoints",
      },
      {
        "<leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes, { border = "rounded" })
        end,
        desc = "DAP Scopes",
      },
      { "<F1>",  function() require("dap.ui.widgets").hover(nil, { border = "rounded" }) end },
      { "<F5>",  "<CMD>DapContinue<CR>",                                                     desc = "DAP Continue" },
      { "<F10>", "<CMD>DapStepOver<CR>",                                                     desc = "Step Over" },
      { "<F11>", "<CMD>DapStepInto<CR>",                                                     desc = "Step Into" },
      { "<F12>", "<CMD>DapStepOut<CR>",                                                      desc = "Step Out" },
      {
        "<leader>dv",
        "<Cmd>DapVirtualTextToggle<Cr>",
        desc = "Toggle (D)AP (V)irtual Text",
      }
    },
  }
}
